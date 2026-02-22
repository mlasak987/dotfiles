import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk, GLib
import os

GLib.set_prgname("volume-popup")

class VolumeSlider(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="VolumeControlPopup")
        
        self.set_wmclass("volume-popup", "volume-popup")
        self.set_name("window")
        self.set_border_width(15)
        self.set_default_size(250, 100)
        self.set_resizable(False)
        self.set_keep_above(True)
        self.set_decorated(False)

        try:
            current_vol = int(os.popen("pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -1").read())
        except:
            current_vol = 50

        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(vbox)

        label = Gtk.Label(label="Volume")
        label.set_name("prompt")
        vbox.pack_start(label, False, False, 0)

        ad1 = Gtk.Adjustment(value=current_vol, lower=0, upper=100, step_increment=1, page_increment=10, page_size=0)
        self.scale = Gtk.Scale(orientation=Gtk.Orientation.HORIZONTAL, adjustment=ad1)
        self.scale.set_name("input")
        self.scale.set_digits(0)
        self.scale.connect("value-changed", self.on_value_changed)
        vbox.pack_start(self.scale, True, True, 0)

        btn = Gtk.Button(label="Open Mixer")
        btn.connect("clicked", self.on_mixer_clicked)
        vbox.pack_start(btn, False, False, 0)

        self.connect("focus-out-event", self.on_focus_out)
        self.connect("key-press-event", self.on_key_press)
        
        self.show_all()

    def on_value_changed(self, scroll):
        val = int(scroll.get_value())
        os.system(f"pactl set-sink-volume @DEFAULT_SINK@ {val}%")

    def on_mixer_clicked(self, widget):
        os.system("pavucontrol &")
        Gtk.main_quit()

    def on_focus_out(self, widget, event):
        Gtk.main_quit()
        return True

    def on_key_press(self, widget, event):
        Gtk.main_quit()
        return True

style_provider = Gtk.CssProvider()
style_provider.load_from_data(b"""
    window { background-color: rgba(30, 30, 46, 0.95); border: 2px solid #33ccff; border-radius: 6px; }
    label#prompt { color: #ffffff; font-weight: bold; font-family: 'JetBrainsMono Nerd Font'; font-size: 14px; }
    scale#input trough { background-color: #313244; min-height: 10px; border-radius: 10px; }
    scale#input highlight { background-color: #33ccff; border-radius: 10px; }
    scale#input slider { background-image: none; background-color: #33ccff; border: 0px; min-height: 18px; min-width: 18px; margin: -5px 0; }
    scale#input slider:hover { background-image: none; background-color: #33ccff; border: 2px solid #ffffff; min-height: 18px; min-width: 18px; margin: -5px 0; }
    button { background-image: none; background-color: #313244; color: #33ccff; border-radius: 8px; border: 0px; padding: 5px; margin-top: 5px; text-shadow: none; box-shadow: none; }
    button:hover { background-image: none; background-color: #33ccff; color: #ffffff; }
""")
Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), style_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

win = VolumeSlider()
Gtk.main()
