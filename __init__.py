from mycroft import MycroftSkill, intent_file_handler
from pathlib import Path
from mycroft.util import play_wav
from mycroft.skills import resting_screen_handler

class MkzUrbanDemo(MycroftSkill):
    def __init__(self):
        MycroftSkill.__init__(self)
        self.sound_file_path = Path(__file__).parent.joinpath("sounds", "mkz-welcome-chime2.wav")
        self.mkzdemo_img = Path(__file__).parent.joinpath("images", "mkz-lincoln-day.png")
        self.settings["wallpaper_file"] = "custom-wallpaper.jpg"
        self.settings["wallpaper_url"] = str(self.mkzdemo_img)
        #self.mkz_ui = Path(__file__).parent.joinpath("ui", "mkz.qml")
        #self.mkz_9grid_ui = Path(__file__).parent.joinpath("ui", "mkz-9grid-buttons.qml")
        self.mkz_list_ui = Path(__file__).parent.joinpath("ui", "mkz-list-buttons.qml")
        self.gui['actionsList'] = []
        self.gui['background'] = str(self.mkzdemo_img)
        self.ad['status'] = {"power": "off", "engine": "off", "autonomy": "off", "doors": "closed"}
        self.ad['health'] = {"power": "ok", "compute": "ok", "vehicle": "ok", "sensors": "ok", "tires": "ok", "network": "ok"}
        self.ad['autonomy'] = {"level": "off"}
        self.ad['exceptions'] = {}
        self.ad_status_announce = true

   #@resting_screen_handler('MKZ homescreen')
   #def handle_homescreen(self, message):
        #self.gui.clear()
        #self.enclosure.display_manager.remove_active()
        #self.gui.show_image(str(self.mkzdemo_img))

    @intent_file_handler('demo.urban.mkz.intent')
    def handle_demo_urban_mkz(self, message):
        self.gui.clear()
        self.enclosure.display_manager.remove_active()
        play_proc = play_wav(str(self.sound_file_path))
        #self.gui.show_page(str(self.mkz_list_ui), override_idle=True)
        self.speak_dialog('demo.urban.mkz', wait=True)
        self.schedule_event(self._ask_what_to_do, 5)

    #@intent_file_handler('status.ad.mkz.intent')
    #def ad_status_mkz(self, message):
        #ad_type = message.data.get('type')
        #ad_item = message.data.get('item')
        #ad_value = message.data.get('value')
        #self.ad[ad_type][ad_item]=ad_value
        #self.speak(ad_type+" "+ad_item+" "+ad_value)

    def _ask_what_to_do(self):
        self.speak("What's next?", expect_response=True, wait=True)
        self.gui['actionsList'] = [{"text": "Activate", "image": "../images/Power-button.png"},
                                    {"text": "Drive", "image": "../images/Start-button.png"},
                                    {"text": "Setting", "image": "../images/Settings-symbol.png"}]
        self.gui.show_page(str(self.mkz_list_ui), override_idle=True)
        
def create_skill():
    return MkzUrbanDemo()
