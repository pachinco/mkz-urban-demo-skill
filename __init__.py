from mycroft import MycroftSkill, intent_file_handler
from pathlib import Path
from mycroft.util import play_wav
from mycroft.skills import resting_screen_handler
from datetime import datetime

class MkzUrbanDemo(MycroftSkill):
    def __init__(self):
        MycroftSkill.__init__(self)
        self.sound_file_path = Path(__file__).parent.joinpath("sounds", "mkz-welcome-chime2.wav")
        self.mkzdemo_img = Path(__file__).parent.joinpath("images", "mkz_background_stage_day.png")
        self.mkzdemo_over = Path(__file__).parent.joinpath("images", "MKZ-background-frame-day.png")
        #self.mkzdemo_img = "../images/mkz_background_center_day.png"
        #self.settings["wallpaper_file"] = "custom-wallpaper.jpg"
        #self.settings["wallpaper_url"] = str(self.mkzdemo_img)
        #self.mkz_ui = Path(__file__).parent.joinpath("ui", "mkz.qml")
        #self.mkz_9grid_ui = Path(__file__).parent.joinpath("ui", "mkz-9grid-buttons.qml")
        self.mkz_list_ui = Path(__file__).parent.joinpath("ui", "mkz-line-buttons.qml")
        self.mkz_home_ui = Path(__file__).parent.joinpath("ui", "mkz.qml")
        self.gui["actionsList"] = []
        self.gui["background"] = str(self.mkzdemo_img)
        self.gui["foreground"] = str(self.mkzdemo_over)
        self.gui["datetime"] = ""
        self.gui["uiIdx"] = -2
        #self.log.info("backgroundimage: "+str(self.mkzdemo_img))
        self.ad={}
        self.ad["control"] = {"power": "off", "engine": "off", "autonomy": "disabled", "doors": "locked"}
        self.ad["operation"] = {"power": "okay", "compute": "okay", "vehicle": "okay", "sensors": "okay", "tires": "okay", "network": "okay"}
        #self.ad["exceptions"] = {}
        self.ad_status_announce = True

    @resting_screen_handler('MKZ homescreen')
    def handle_homescreen(self, message):
        self.gui.clear()
        #self.enclosure.display_manager.remove_active()
        self.log.info('Activating MKZ homescreen')
        self.gui.show_image("image/mkz_background_stage_day.png", override_idle=True, override_animations=True)

    @intent_file_handler('demo.urban.mkz.intent')
    def handle_demo_urban_mkz(self, message):
        self.gui.clear()
        self.gui["uiIdx"] = -2
        self.gui["uiButtons"] = [{"ui": "config", "idx": 0, "image": "../images/LightningIcon.png"},
                                  {"ui": "map", "idx": 1, "image": "../images/NavigationIcon.png"},
                                  {"ui": "car", "idx": 2, "image": "../images/CarIcon.png"},
                                  {"ui": "music", "idx": 3, "image": "../images/MediaIcon.png"},
                                  {"ui": "weather", "idx": 4, "image": "../images/CloudIcon.png"}]
        #self.enclosure.display_manager.remove_active()
        play_proc = play_wav(str(self.sound_file_path))
        self.gui.show_page(str(self.mkz_home_ui), override_idle=True)
        self.speak_dialog('demo.urban.mkz', wait=True)
        self.schedule_repeating_event(self._update_display_time, None, 10)
        self.schedule_event(self._whats_next, 3)

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
        self.gui.clear()
        self.enclosure.display_manager.remove_active()
        s=message.data["utterance"][10:]
        ad_type = message.data.get('type')
        self.log.info("query status: type="+ad_type)
        if (ad_type not in self.ad.keys()):
            self.speak("there is no such status to report.", wait=True)
        elif (len(self.ad[ad_type])==0):
            if (ad_type[-1]=="s"):
                self.speak("there are no "+ad_type+" to report.", wait=True)
            else:
                self.speak("there is no "+ad_type+" to report.", wait=True)
        else:
            self.speak("here is the "+ad_type+" status report.", wait=True)
            for ad_item, ad_value in self.ad[ad_type].items():
                if (ad_item[-1]=="s"):
                    self.speak("the "+ad_item+" are "+ad_value+".", wait=True)
                else:
                    self.speak("the "+ad_item+" is "+ad_value+".", wait=True)

    def _whats_next(self):
        #self.gui.clear()
        #self.enclosure.display_manager.remove_active()
        #self.speak("What's next?", expect_response=True, wait=True)
        #self.gui.show_page(str(self.mkz_list_ui))
        self.gui["uiIdx"] = -1
        self.schedule_event(self._switch_config, 3)

    def _switch_config(self):
        self.gui["actionsList"] = []
        self.gui["uiIdx"] = 2
        self.schedule_event(self._add_config, 1)
        
    def _add_config(self):
        self.gui["uiIdx"] = 2
        self.gui["actionsList"] = [{"text": "Activate", "image": "../images/Power-button.png"},
                                    {"text": "Drive", "image": "../images/Start-button.png"},
                                    {"text": "Setting", "image": "../images/Settings-symbol.png"}]
        self.schedule_event(self._back_map, 5)

    def _back_map(self):
        self.gui["uiIdx"] = 1
        self.schedule_event(self._back_config, 5)

    def _back_config(self):
        self.gui["uiIdx"] = 0
        self.schedule_event(self._back_home, 5)
        self.gui["configList"] = [{"text": "▾ Vehicle ✓"},
                                  {"text": "▾   Doors ❌"},
                                  {"text": "      Front Left ❌"},
                                  {"text": "      Front Right ✓"},
                                  {"text": "      Rear Left ✓"},
                                  {"text": "      Rear Right ✓"},
                                    {"text": "▸ Sensors ✓"},
                                    {"text": "▸ Driver ✓"},
                                    {"text": "▸ Compute ✓"},
                                    {"text": "▸ Communication ✓"},
                                    {"text": "▸ Environment ✓"}]

    def _back_home(self):
        self.gui["uiIdx"] = -1

    def _update_display_time(self):
        dt = datetime.now()
        dt_str = dt.strftime("%I:%M %p   %a %b %-d")
        self.log.info("datetime: "+dt_str)
        #hh_mm = nice_time(dt, speech=False, use_24hour=False)
        self.gui["datetime"] = dt_str

def create_skill():
    return MkzUrbanDemo()
