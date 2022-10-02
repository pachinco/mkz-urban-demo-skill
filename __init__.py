from mycroft import MycroftSkill, intent_file_handler
from pathlib import Path
from mycroft.util import play_wav
from mycroft.skills import resting_screen_handler

class MkzUrbanDemo(MycroftSkill):
    def __init__(self):
        MycroftSkill.__init__(self)
        self.sound_file_path = Path(__file__).parent.joinpath("sounds", "mkz-welcome-chime2.wav")
        self.mkzdemo_img = Path(__file__).parent.joinpath("images", "mkz_background2.png")
        self.settings["wallpaper_file"] = "custom-wallpaper.jpg"
        self.settings["wallpaper_url"] = str(self.mkzdemo_img)
        self.mkz_ui = Path(__file__).parent.joinpath("ui", "mkz.qml")

   #@resting_screen_handler('MKZ homescreen')
   #def handle_homescreen(self, message):
        #self.gui.clear()
        #self.enclosure.display_manager.remove_active()
        #background_img = self.settings.get("background_img", self.mkzdemo_img)
        #self.gui.show_image(str(self.mkzdemo_img))

    @intent_file_handler('demo.urban.mkz.intent')
    def handle_demo_urban_mkz(self, message):
        self.gui.clear()
        self.enclosure.display_manager.remove_active()
        play_proc = play_wav(str(self.sound_file_path))
        #self.gui["actionsList"] = [{{"name":"Setting","phone":"(444) 444-4444"},{"name":"Drive","phone":"(555) 555-5555"}}]
        actionsObject = {}
        actionsList = [{"text": "Drive",
                       "image": "../images/settings-icon-10.png"},
                      {"text": "System",
                       "image": "../images/settings-icon-10.png"},
                      {"text": "Settings",
                       "image": "../images/settings-icon-10.png"},
                      {"text": "Other",
                       "image": "../images/settings-icon-10.png"}]
        actionsObject['actions'] = actionsList
        self.gui['actionsList'] = actionsObject
        self.gui['background'] = str(self.mkzdemo_img)
        self.gui.show_page(str(self.mkz_ui), override_idle=True)
        self.speak_dialog('demo.urban.mkz')
 
def create_skill():
    return MkzUrbanDemo()

