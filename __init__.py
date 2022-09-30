from mycroft import MycroftSkill, intent_file_handler

from mycroft.util import play_wav

class MkzUrbanDemo(MycroftSkill):
    def __init__(self):
        MycroftSkill.__init__(self)
        self.sound_file_path = Path(__file__).parent.joinpath("sounds", "mkz-welcome-chime.wav")

    @intent_file_handler('demo.urban.mkz.intent')
    def handle_demo_urban_mkz(self, message):
        play_proc = play_wav(str(self.sound_file_path))
        self.speak_dialog('demo.urban.mkz')


def create_skill():
    return MkzUrbanDemo()

