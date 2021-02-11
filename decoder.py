import numpy as np 
import pickle 

import openpifpaf.decoder.cifcaf as OriginalDecoder

from openpifpaf import visualizer
from openpifpaf.datasets.constants import COCO_KEYPOINTS, COCO_PERSON_SKELETON

class CifCafDecoder():
    def __init__(self):
        self.cif_metas = pickle.load(open( "/repo/cif_metas.pkl", "rb" ))
        self.caf_metas = pickle.load(open( "/repo/caf_metas.pkl", "rb" ))
        self._decoder = OriginalDecoder.CifCaf(cif_metas = self.cif_metas, 
                                                caf_metas = self.caf_metas) 

    def decode(self, fields):
        return self._decoder(fields)

