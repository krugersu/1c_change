import unittest
import main


class MainTest(unittest.TestCase):
    def test_find_change(self):
        """ variant 1:
        A ... A
        """
        self.assertEqual (main.find_change('//+КХ_Пашков_Д_# aaaaaa //-КХ_Пашков_Д_# sdsdsd '),' aaaaaa ')
        """ variant 2:
        A ... A B ... B
        """
        self.assertEqual (main.find_change('//+КХ_Пашков_Д_# aaaaaa //-КХ_Пашков_Д_# sdsdsd //+КХ_Пашков_Д_24# bbb //-КХ_Пашков_Д_24# '),' aaaaaa  bbb ')
        """ variant 3:
        A ... B ... A ... B
        """
        self.assertEqual (main.find_change('//+КХ_1_# aaaaaa //+КХ_24_# xx //-КХ_1_# sdsdsd //-КХ_24_# '),' aaaaaa //+КХ_24_# xx  xx //-КХ_1_# sdsdsd ')
        """ variant 4:
        A ... B ... B ... A
        """
        self.assertEqual (main.find_change('//+КХ_1_# aaaaaa //+КХ_24_#  sdsdsd //-КХ_24_#  xx //-КХ_1_# '),' aaaaaa //+КХ_24_#  sdsdsd //-КХ_24_#  xx   sdsdsd ')
    
        
if __name__ == '__main__':
    unittest.main()