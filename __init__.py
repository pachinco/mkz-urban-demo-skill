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
        self.actionsObject = {}
        self.actionsList = []
        self.actionsObject['actions'] = self.actionsList
        self.gui['actionsList'] = self.actionsObject

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
        self.actionsObject = {}
        self.actionsList = []
        self.actionsObject['actions'] = self.actionsList
        self.gui['actionsList'] = self.actionsObject
        self.gui['background'] = str(self.mkzdemo_img)
        self.gui.show_page(str(self.mkz_list_ui), override_idle=True)
        self.speak_dialog('demo.urban.mkz', wait=True)
        self.schedule_event(self._ask_what_to_do, 15)

    def _ask_what_to_do(self):
        self.speak('What would you like to do?', expect_response=True, wait=True)
        self.actionsList.append({"text": "Activate", "image": "../images/Power-button.png"})
        self.actionsList.append({"text": "Drive", "image": "../images/Start-button.png"})
        #self.actionsList.append({"text": "Proceed", "image": "../images/Forward-button.png"})
        self.actionsList.append({"text": "Setting", "image": "../images/Settings-symbol.png"})
        self.gui['actionsList']['actions'].append({"text": "Activate", "image": "../images/Power-button.png"})
        self.gui['actionsList']['actions'].append({"text": "Drive", "image": "../images/Start-button.png"})
        self.gui['actionsList']['actions'].append({"text": "Setting", "image": "../images/Settings-symbol.png"})
        #self.actionsObject['actions'] = self.actionsList
        #self.gui['actionsList'] = self.actionsObject
        
def create_skill():
    return MkzUrbanDemo()
