from mycroft import MycroftSkill, intent_file_handler


class MkzUrbanDemo(MycroftSkill):
    def __init__(self):
        MycroftSkill.__init__(self)

    @intent_file_handler('demo.urban.mkz.intent')
    def handle_demo_urban_mkz(self, message):
        self.speak_dialog('demo.urban.mkz')


def create_skill():
    return MkzUrbanDemo()

