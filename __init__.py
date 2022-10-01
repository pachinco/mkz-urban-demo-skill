from mycroft import MycroftSkill, intent_file_handler
from pathlib import Path
from mycroft.util import play_wav
from mycroft.skills import resting_screen_handler

class MkzUrbanDemo(MycroftSkill):
    def __init__(self):
        MycroftSkill.__init__(self)
        self.sound_file_path = Path(__file__).parent.joinpath("sounds", "mkz-welcome-chime2.wav")
        self.mkzdemo_img = Path(__file__).parent.joinpath("images", "mkz_homescreen.png")
#        self.settings["wallpaper_url"]=str(self.mkzdemo_img)

    @resting_screen_handler('MKZ homescreen')
    def handle_homescreen(self, message):
#        background_img = self.settings.get("background_img", self.mkzdemo_img)
#        background_img = self.settings.get("background_img", self.mkzdemo_img)
#        self.gui.show_image(self,str(self.mkzdemo_img),fill=Stretch,override_idle=True)
#        self.gui.show_image(str(self.mkzdemo_img))
        self.gui.show_image(str(self.sound_file_path))

    @intent_file_handler('demo.urban.mkz.intent')
    def handle_demo_urban_mkz(self, message):
#        self.gui.show_image(self,str(self.mkzdemo_img),fill=Stretch,override_idle=True)
        self.gui.show_image(str(self.mkzdemo_img))
        play_proc = play_wav(str(self.sound_file_path))
        self.speak_dialog('demo.urban.mkz')

def create_skill():
    return MkzUrbanDemo()

