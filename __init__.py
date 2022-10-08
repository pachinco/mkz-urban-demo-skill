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
        self.ad={}
        self.ad["system"] = {"power": "off", "engine": "off", "autonomy": "off", "doors": "closed"}
        self.ad["health"] = {"power": "okay", "compute": "okay", "vehicle": "okay", "sensors": "okay", "tires": "okay", "network": "okay"}
        self.ad["exceptions"] = {}
        self.ad["failure"] = {}
        self.ad_status_announce = True

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

    @intent_file_handler('status.ad.mkz.intent')
    def handle_ad_status_mkz(self, message):
        s=message.data["utterance"][10:]
        i1=s.index(" ")
        i2=s[i1+1:].index(" ")
        ad_type = s[0:i1]
        ad_item = s[i1+1:i1+i2+1]
        ad_value = s[i1+i2+2:]
        self.log.info("ad status: type="+ad_type+" item="+ad_item+" value="+ad_value)
        if (ad_type not in self.ad.keys()):
            self.ad[ad_type]={}
        else:
            self.ad[ad_type][ad_item]=ad_value
        if (self.ad_status_announce):
            self.speak(ad_type+" status."+" the "+ad_item+" is "+ad_value, wait=True)

    @intent_file_handler('status.query.mkz.intent')
    def handle_query_status_mkz(self, message):
        s=message.data["utterance"][10:]
        ad_type = message.data.get('type')
        self.log.info("query status: type="+ad_type)
        if (self.ad[ad_type].items()=={}):
            if (ad_type[-1]=="s"):
                self.speak("currently there are no "+ad_type+" to report.")
            else:
                self.speak("currently there is no "+ad_type+" status to report.")
        else:
            self.speak("here is the "+ad_type+" status report.")
            for ad_item, ad_value in self.ad[ad_type].items():
                if (ad_item[-1]=="s"):
                    self.speak("the "+ad_item+" are "+ad_value+".")
                else:
                    self.speak("the "+ad_item+" is "+ad_value+".")

    def _ask_what_to_do(self):
        self.speak("What's next?", expect_response=True, wait=True)
        self.gui['actionsList'] = [{"text": "Activate", "image": "../images/Power-button.png"},
                                    {"text": "Drive", "image": "../images/Start-button.png"},
                                    {"text": "Setting", "image": "../images/Settings-symbol.png"}]
        self.gui.show_page(str(self.mkz_list_ui), override_idle=True)
        
def create_skill():
    return MkzUrbanDemo()
