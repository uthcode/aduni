### Blake Asdorian, 4/18/01
### School Registration Page for SecondarySources.com

import Ns
import string
import re

conn = Ns.GetConn()
    
####### retrieve query data
try:
     query = conn.GetQuery()
     query_exists = 1
     email = string.strip(query.Get('email'))
     first_names = string.strip(query.Get('first_names'))
     last_name = string.strip(query.Get('last_name'))
     url = string.strip(query.Get('url'))
     street_address = string.strip(query.Get('street_address'))
     city = string.strip(query.Get('city'))
     state = string.strip(query.Get('state'))
     zipcode = string.strip(query.Get('zipcode'))
     office_phone = string.strip(query.Get('office_phone'))
     mobile_phone = string.strip(query.Get('mobile_phone'))
     fax = string.strip(query.Get('fax'))
     affiliations = []
     for data in range(query.Size()):
          if (cmp(query.Key(data),'school_id') == 0):
               affiliations = affiliations + [query.Value(data)]
except:
     query_exists = 0
     email = ''
     first_names = ''
     last_name = ''
     url = ''
     street_address = ''
     city = ''
     state = ''
     zipcode = ''
     office_phone = ''
     mobile_phone = ''
     fax = ''
     affiliations = []
     
###### do some error checking on the input
email_error = ''
first_names_error = ''
last_name_error = ''
valid_input = 0

## check e-mail for correct pattern
legal_email = re.compile(r'[a-zA-Z][\w-]*@\w+\.\w+')

if (query_exists):
## check e-mail for correct pattern
     valid_email = legal_email.match(email)
     if (cmp(first_names,'') == 0):
          first_names_error = '<FONT SIZE=4 COLOR=RED> Please Enter First Names</FONT>'
     elif (cmp(last_name,'') == 0):
          last_name_error = '<FONT SIZE=4 COLOR=RED> Please Enter Last Name</FONT>'
     elif not (valid_email):
          email_error = '<FONT SIZE=4 COLOR=RED> Please Enter a Valid Email Address</FONT>'
     
     else:
          valid_input = 1
     
###################### generate the appropriate page, depending on input 
if (valid_input == 0):

############ if the input had problems, or if first visiting the registraion page #################
###### generate select elements html
     school_sql = 'SELECT school_id,school_name FROM schools'
     try:
          db = Ns.DbHandle(Ns.DbPoolDefault(conn.Server()))
          school_req = db.Select(school_sql)
     except:
          conn.ReturnRedirect('error_page')
               
     school_list = ''
     while (db.GetRow(school_req) != Ns.END_DATA):
          if school_req.IGet('school_id') in affiliations:
               selected = 'SELECTED'
          else:
               selected = ''
          school_list = school_list + '''<OPTION %s VALUE="%s">%s</OPTION>''' % (selected, school_req.IGet('school_id'),school_req.IGet('school_name'))
               
     if (school_list != ''):
          school_list = '<SELECT NAME=school_id MULTIPLE SIZE=17>' + school_list + '</SELECT>'

########## generate the html code for the registration page
     html = '''
     <HTML>
     <head><title>Secondary Sources</title>
     </head>
     <body bgcolor=white>
     <HR>
     <H2>SecondarySources.com</H2>
     <H3>Person Registration</H3>
     <HR>
     <form METHOD=POST action=person_reg.py>
     <TABLE>
     <TR>
     <TD>First Names:
     <TD COLSPAN=3><INPUT TYPE=TEXT NAME=first_names VALUE="%s" SIZE=30>%s
     <TD>Affiliation:
     <TD ROWSPAN=8>%s
     </TR>
     <TR>
     <TD>Last Name:
     <TD COLSPAN=3><INPUT TYPE=TEXT NAME=last_name VALUE="%s" SIZE=30>%s
     <TD>
     </TR>
     <TR>
     <TD>Email:
     <TD COLSPAN=3><INPUT TYPE=TEXT NAME=email VALUE="%s" SIZE=30>%s
     </TR>
     <TR>
     <TD>Url:
     <TD COLSPAN=3><INPUT TYPE=TEXT NAME=url VALUE="%s" SIZE=68>
     </TR>
     <TR>
     <TD>Street Address:
     <TD COLSPAN=3><INPUT TYPE=TEXT NAME=street_address VALUE="%s" SIZE=68>
     </TR>
     <TR>
     <TD>City:
     <TD><INPUT TYPE=TEXT NAME=city VALUE="%s" SIZE=25>
     <TD>Work Phone:
     <TD><INPUT TYPE=TEXT NAME=office_phone VALUE="%s" SIZE=25>
     </TR>
     <TR>
     <TD>State:
     <TD><INPUT TYPE=TEXT NAME=state VALUE="%s" SIZE=25>
     <TD>Mobile Phone:
     <TD><INPUT TYPE=TEXT NAME=mobile_phone VALUE="%s" SIZE=25>
     </TR>
     <TR>
     <TD>Zip Code:
     <TD><INPUT TYPE=TEXT NAME=zipcode VALUE="%s" SIZE=25>
     <TD>Fax:
     <TD><INPUT TYPE=TEXT NAME=fax VALUE="%s" SIZE=25>
     </TR>
     <TR>
     <TD COLSPAN=6 ALIGN=CENTER><INPUT TYPE=SUBMIT VALUE=Register>
     </TR>
     </TABLE>
     </FORM>
     </HTML>
     ''' % (first_names,first_names_error,school_list,last_name,last_name_error,email,email_error,url,street_address,city,state,zipcode,office_phone,mobile_phone,fax)

elif (valid_input == 1):
############################ if all fields contained valid input, insert data and return completion page w/link to (main page or school page)?
       persons_sql = '''insert into persons (email,first_names,last_name,date_registered,url,street_address,city,state,zipcode,office_phone,mobile_phone,fax) VALUES ('%s','%s','%s',CURRENT_TIMESTAMP,'%s','%s','%s','%s','%s','%s','%s','%s')''' % (re.escape(email),re.escape(first_names),re.escape(last_name),re.escape(url),re.escape(street_address),re.escape(city),re.escape(state),re.escape(zipcode),re.escape(office_phone),re.escape(mobile_phone),re.escape(fax))
       try:
            db = Ns.DbHandle(Ns.DbPoolDefault(conn.Server()))
            db.DML(persons_sql)
            person_id = db.Select('''Select person_id from persons where email='%s'''' % (re.escape(email)))
            for school in affiliations:
                 db.DML(('''insert into person_school_map (person_id,school_id) VALUES (%s,%s)''' % (person_id,school)))
       except:
            conn.ReturnRedirect('error_page')
     
       html = '''
       <HTML>
       <head><title>Secondary Sources</title>
       </head>
       <body bgcolor=white>
       <HR>
       <H2>School Registration</H2>
       <HR>
       <H4>You have successfully registered yourself with SecondarySources.com</H4>
       return to
       <A HREF="main_page">main page.</A>
       <HR>
       </BODY>
       </HTML>'''

#####################################################################
conn.ReturnHtml(200, html)


















