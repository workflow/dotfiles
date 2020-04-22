{ pkgs }:

let

  icon = "${./icon_small.png}";

in

pkgs.writeScriptBin "indicator-redshift" ''
  #! /usr/bin/env nix-shell
  #! nix-shell -i python2 -p python27 python27Packages.pygobject3 -p libappindicator-gtk3 -p gobjectIntrospection

  import os
  import signal
  from subprocess import call

  import gi
  gi.require_version('Gtk', '3.0')
  gi.require_version('AppIndicator3', '0.1')
  from gi.repository import Gtk, AppIndicator3

  ICON = '${icon}'

  ENV = os.environ.copy()
  ENV.setdefault('DISPLAY', ':0')

  REDSHIFT_CMD = '${pkgs.redshift}/bin/redshift'

  class Indicator(object):

      def __init__(self):
          self.indicator = AppIndicator3.Indicator.new(
              'indicator-redshift',
              ICON,
              AppIndicator3.IndicatorCategory.OTHER
          )
          self.temp = '4500'
          self.indicator.set_status(AppIndicator3.IndicatorStatus.ACTIVE)
          self.indicator.set_menu(self.build_menu())
          self.disable_redshift()
          self.enabled = False

      def build_menu(self):
          menu = Gtk.Menu()

          self.item_toggle = Gtk.CheckMenuItem('Enabled')
          self.item_toggle.connect('toggled', self.toggle_redshift)
          menu.append(self.item_toggle)

          set_temp = Gtk.MenuItem('Set temp')
          set_temp.connect('activate', self.get_new_temp)
          menu.append(set_temp)

          menu_sep = Gtk.SeparatorMenuItem()
          menu.append(menu_sep)

          item_quit = Gtk.MenuItem('Quit')
          item_quit.connect('activate', self.stop)
          menu.append(item_quit)

          menu.show_all()

          return menu

      def stop(self, source):
          self.disable_redshift()
          Gtk.main_quit()

      def disable_redshift(self):
          call([REDSHIFT_CMD, '-x'], env=ENV)
          self.enabled = False

      def enable_redshift(self):
          call([REDSHIFT_CMD, '-P', '-O', self.temp], env=ENV)
          self.enabled = True
          self.item_toggle.set_active(True)

      def toggle_redshift(self, source):
          if source.get_active():
              self.enable_redshift()
          else:
              self.disable_redshift()

      def get_new_temp(self, _):
          win = GetNewValueWindow(self, self.temp)
          win.show_all()

      def set_new_temp(self, temp):
          if not (isinstance(temp, str) and temp.isdigit()):
              return

          self.temp = temp

          self.enable_redshift()


  class GetNewValueWindow(Gtk.Window):
      def __init__(self, parent, initial=""):
          Gtk.Window.__init__(self, title='New value')
          self.set_wmclass('indicator.py', 'Indicator.py')
          self.timeout_id = None
          self.set_position(Gtk.WindowPosition.CENTER)
          self.set_default_size(400, 100)

          self.parent = parent

          vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
          self.add(vbox)

          adj = Gtk.Adjustment(int(initial), 2500, 6000, 100, 100, 100)
          self.slider = Gtk.Scale(
              orientation=Gtk.Orientation.HORIZONTAL,
              adjustment=adj
          )
          self.slider.set_digits(0)
          self.slider.set_hexpand(True)
          self.slider.connect('value-changed', self.on_value_change)

          # self.val = Gtk.Entry()
          # self.val.set_text(initial)
          # self.val.connect('activate', self.on_activate)
          # vbox.pack_start(self.val, True, True, 0)

          vbox.pack_start(self.slider, True, True, 0)

          bbox = Gtk.Box(spacing=15)
          vbox.pack_start(bbox, True, True, 0)

          self.btn = Gtk.Button.new_with_label('Done')
          self.btn.connect('clicked', self.on_activate)
          bbox.pack_start(self.btn, True, True, 0)

          vbox.connect('key-release-event', self.on_key_release)

      def on_value_change(self, scale_obj):
          self.parent.set_new_temp(str(int(scale_obj.get_value())))

      def on_activate(self, _):
          # self.parent.set_new_temp(self.val.get_text())
          self.destroy()

      def on_key_release(self, widget, event, data=None):
          # exit on ENTER or ESC
          if event.keyval in [65293, 65307]:  # TODO: find constants
              self.destroy()

  def main():
      indicator = Indicator()
      signal.signal(signal.SIGINT, signal.SIG_DFL)
      Gtk.main()

  if __name__ == "__main__":
      main()
''
