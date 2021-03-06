
# makefile for compiling the sun.w.demo.classfile utility classes.

SRCDIR = sunw\demo\classfile

CLASSFILES= \
		$(SRCDIR)\Attribute.class				\
		$(SRCDIR)\ClassConstant.class				\
		$(SRCDIR)\ClassFile.class				\
		$(SRCDIR)\Code.class					\
		$(SRCDIR)\ConstantPoolEntry.class			\
		$(SRCDIR)\ConstantValue.class				\
		$(SRCDIR)\DelegatorClassFile.class			\
		$(SRCDIR)\DoubleConstant.class				\
		$(SRCDIR)\EncapsulatedEventAdaptorClassFile.class	\
		$(SRCDIR)\Exceptions.class			 	\
		$(SRCDIR)\FieldConstant.class				\
		$(SRCDIR)\FieldDesc.class				\
		$(SRCDIR)\FloatConstant.class				\
		$(SRCDIR)\IntegerConstant.class				\
		$(SRCDIR)\InterfaceMethodConstant.class			\
		$(SRCDIR)\LongConstant.class				\
		$(SRCDIR)\MethodConstant.class				\
		$(SRCDIR)\MethodDesc.class				\
		$(SRCDIR)\NameAndTypeConstant.class			\
		$(SRCDIR)\RefConstant.class				\
		$(SRCDIR)\StringConstant.class				\
		$(SRCDIR)\UTF8Constant.class

.SUFFIXES: .java .class

all: $(CLASSFILES)

# Rule for compiling a normal .java file
{$(SRCDIR)}.java{$(SRCDIR)}.class :
	set CLASSPATH=.
	javac $<

clean:
	-del $(SRCDIR)\*.class
