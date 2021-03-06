#!/usr/local/bin/ruby

=begin header

  testgtk.rb - testgtk.c rewritten in ruby-gtk

  Rewritten by Hiroshi IGARASHI <igarashi@ueda.info.waseda.ac.jp>

Original Copyright:
 
  GTK - The GIMP Toolkit
  Copyright (C) 1995-1997 Peter Mattis, Spencer Kimball and Josh MacDonald
 
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Library General Public
  License as published by the Free Software Foundation; either
  version 2 of the License, or (at your option) any later version.
 
  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Library General Public License for more details.
 
  You should have received a copy of the GNU Library General Public
  License along with this library; if not, write to the
  Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  Boston, MA 02111-1307, USA.

=end

require 'gtk'
require 'sample'
require 'button'
require 'checkbutton'
require 'togglebutton'
require 'radiobutton'
require 'buttonbox'
require 'toolbar'
require 'statusbar'
require 'tree'
require 'handlebox'
require 'reparent'
require 'pixmap'
require 'tooltips'
require 'labels'
require 'layout'
require 'menu'
require 'scrolledwindow'
require 'entry'
require 'spinbutton'
require 'cursors'
require 'list'
require 'clist'
require 'colorselect'
require 'ctree'
require 'dialog'
require 'range'
require 'rulers'
require 'text'
require 'notebook'
require 'panes'
require 'dnd'
require 'shapedwindow'
require 'wmhints'
require 'progressbar'
require 'colorpreview'
require 'graypreview'
require 'selection'
require 'gammacurve'
require 'scroll'
require 'timeout'
require 'idle'
require 'mainloop'
require 'savedposition'
require 'filesel'

#
# Main Window
#
def create_main_window
  buttons = [
    ["button box", ButtonBoxSample],
    ["buttons", ButtonSample],
    ["check buttons", CheckButtonSample],
    ["clist", CListSample],
    ["color selection", ColorSelectionSample],
    ["ctree", CTreeSample],
    ["cursors", nil],
    ["dialog", DialogSample],
    #["dnd", nil],
    ["entry", EntrySample],
    ["event watcher", nil],  #create_event_watcher
    ["file selection", FileSelectionSample],
    ["font selection", nil], #create_font_selection
    ["gamma curve", GammaCurveSample],
    ["handle box", nil],
    ["item factory", nil],   #create_item_factory
    ["labels", LabelSample],
    ["layout", LayoutSample],
    ["list", nil],
    ["menus", MenuSample],
    ["modal window", nil],   #create_modal_window
    ["notebook", NotebookSample],
    ["panes", nil],
    ["pixmap", PixmapSample],
    ["preview color", nil],
    ["preview gray", nil],
    ["progress bar", ProgressBarSample],
    ["radio buttons", RadioButtonSample],
    ["range controls", RangeSample],
    ["rc file", nil], #create_rc_file
    ["reparent", ReparentSample],
    ["rulers", RulerSample],
    ["saved position", SavedPositionSample],
    ["scrolled windows", ScrolledWindowSample],
    ["shapes", ShapesSample],
    ["spinbutton", SpinButtonSample],
    ["statusbar", StatusbarSample],
    ["test idle", nil],
    ["test mainloop", nil],
    ["test scrolling", nil],
    ["test selection", nil],
    ["test timeout", nil],
    ["text", TextSample],
    ["toggle buttons", ToggleButtonSample],
    ["toolbar", ToolbarSample],
    ["tooltips", TooltipsSample],
    ["tree", nil], #TreeSample],
    ["WM hints", WMHintsSample],
  ]
  nbuttons = buttons.size

  window = Gtk::Window.new(Gtk::WINDOW_TOPLEVEL)
  window.set_title($0)
  window.set_policy(false, false, false);
  window.set_name("main window")
  window.set_usize(200, 400)
  window.set_uposition(20, 20)

  window.signal_connect("destroy") do Gtk.main_quit end
  window.signal_connect("delete_event") do false end

  box1 = Gtk::VBox.new(false, 0)
  window.add(box1)

  buffer =
    if Gtk::MICRO_VERSION > 0
      sprintf("Gtk+ v%d.%d.%d",
	      Gtk::MAJOR_VERSION,
	      Gtk::MINOR_VERSION,
	      Gtk::MICRO_VERSION)
    else
      sprintf("Gtk+ v%d.%d",
	      Gtk::MAJOR_VERSION,
	      Gtk::MICRO_VERSION)
    end

  label = Gtk::Label.new(buffer)
  box1.pack_start(label, false, false, 0)

  buffer =
      sprintf("Ruby/GTK v%d.%d.%d",
	      Gtk::BINDING_VERSION[0],
	      Gtk::BINDING_VERSION[1],
	      Gtk::BINDING_VERSION[2])
  label = Gtk::Label.new(buffer)
  box1.pack_start(label, false, false, 0)

  scrolled_window = Gtk::ScrolledWindow.new(nil, nil)
  scrolled_window.border_width(10)
  scrolled_window.set_policy(Gtk::POLICY_AUTOMATIC,
                             Gtk::POLICY_AUTOMATIC)
  box1.pack_start(scrolled_window, true, true, 0)

  box2 = Gtk::VBox.new(false, 0)
  box2.border_width(10)
  scrolled_window.add_with_viewport(box2);
  box2.set_focus_vadjustment(scrolled_window.get_vadjustment)

  for i in 0..(nbuttons-1)
    button = Gtk::Button.new(buttons[i][0])
    unless buttons[i][1].nil?
      button.signal_connect("clicked", buttons[i][1]) do |obj, sample_class|
        sample_class.invoke
      end
    else
      button.set_sensitive(false)
    end
    box2.pack_start(button, true, true, 0)
  end

  separator = Gtk::HSeparator.new
  box1.pack_start(separator, false, true, 0)

  box2 = Gtk::VBox.new(false, 10)
  box2.border_width(10)
  box1.pack_start(box2, false, true, 0)

  button = Gtk::Button.new("close")
  button.signal_connect("clicked") do
    window.destroy
    Gtk.main_quit
  end
  box2.pack_start(button, true, true, 0)
  button.set_flags(Gtk::Widget::CAN_DEFAULT)
  button.grab_default

  window.show_all
end

def main
  srand
  Gtk::RC.parse("testgtkrc")
  #gtk_rc_add_default_file ("testgtkrc");
  #gdk_rgb_init ();

  # bindings test
  #GtkBindingSet *binding_set;
#  binding_set = gtk_binding_set_by_class (gtk_type_class (GTK_TYPE_WIDGET));
#  gtk_binding_entry_add_signal (binding_set,
#				'9', GDK_CONTROL_MASK | GDK_RELEASE_MASK,
#				"debug_msg",
#				1,
#				GTK_TYPE_STRING, "GtkWidgetClass <ctrl><release>9 test");

  create_main_window
  Gtk.main
end

if $DEBUG
  STDERR.sync = true
  # for GC (and thread) test
  Thread.start do
    loop do
      STDERR.print("+")
      GC.start
      sleep(1)
    end
  end
  STDERR.puts("#{$0}: started GC-thread for debugging.")

  # timeout
  Gtk.timeout_add(1000) do
    STDERR.print("*")
    true
  end

  # idle
#  Gtk.idle_add do
#    STDERR.print("?")
#    true
#  end

  # io-blocked thread test
#  Thread.start do
#    loop do
#      buf = STDIN.gets
#      STDERR.puts(buf)
#    end
#  end
end

main
puts("#{$0}: done.")
