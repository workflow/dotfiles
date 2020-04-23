{ pkgs }:

let

  tpacpi-bat = pkgs.callPackage ../tpacpi-bat.nix {};
  tpacpi = "${tpacpi-bat}/bin/tpacpi-bat";

  icon = "${./icon_white_small.png}";

in

pkgs.writeScriptBin "indicator-tpacpi" ''
  #! /usr/bin/env nix-shell
  #! nix-shell -i python2 -p python27 python27Packages.pygobject3 -p libappindicator-gtk3 -p gobjectIntrospection

  import signal
  from subprocess import call

  import gi
  gi.require_version('Gtk', '3.0')
  gi.require_version('AppIndicator3', '0.1')
  from gi.repository import Gtk, AppIndicator3

  ICON = "${icon}"

  START_CHARGE = '${tpacpi} -s ST 1 0 ; ${tpacpi} -s SP 1 0'
  STOP_CHARGE = '${tpacpi} -s ST 1 40 ; ${tpacpi} -s SP 1 80'
  TMPL = "${pkgs.gnome3.zenity}/bin/zenity --password | sudo -k -S -- sh -c '{}'"

  def start_charge():
      return call(TMPL.format(START_CHARGE), shell=True)

  def stop_charge():
      return call(TMPL.format(STOP_CHARGE), shell=True)

  class Indicator(object):

      def __init__(self):
          self.indicator = AppIndicator3.Indicator.new(
              'indicator-tpacpi',
              ICON,
              AppIndicator3.IndicatorCategory.OTHER
          )
          self.info = Gtk.MenuItem()
          self.info.set_sensitive(False)
          self.indicator.set_status(AppIndicator3.IndicatorStatus.ACTIVE)
          self.indicator.set_menu(self.build_menu())

      def build_menu(self):
          menu = Gtk.Menu()

          item_thresh = Gtk.MenuItem('Thresholds')
          item_thresh.connect('activate', self.stop_charge)
          menu.append(item_thresh)

          item_charge = Gtk.MenuItem('Charge')
          item_charge.connect('activate', self.start_charge)
          menu.append(item_charge)

          item_quit = Gtk.MenuItem('Quit')
          item_quit.connect('activate', self.stop)
          menu.append(item_quit)

          menu.show_all()

          return menu

      def stop(self, source):
          Gtk.main_quit()

      def start_charge(self, source):
          start_charge()

      def stop_charge(self, source):
          stop_charge()

  def main():
      indicator = Indicator()
      signal.signal(signal.SIGINT, signal.SIG_DFL)
      Gtk.main()

  if __name__ == "__main__":
      main()
''
