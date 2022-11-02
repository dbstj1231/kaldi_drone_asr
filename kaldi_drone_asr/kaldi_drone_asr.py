import os
import time

class Kaldi_Drone_ASR():
    def __int__(self):
        self.result =''
        
    def kaldi_drone_transcribe(self, file_list_wav):
        # #starting time
        # start = time.time()
       
        self.result = os.popen('./kaldi_drone_asr/kaldi_drone_run.sh '+ str(file_list_wav[0])).read()
        self.result = self.result.split('\n')[-2].split(' ',maxsplit=1)[1].strip().lower()

        # #print the runtime
        # print("Runtime :", time.time() - start)

        return self.result
