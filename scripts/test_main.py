import unittest
import main


class MainTest(unittest.TestCase):
    def test_find_change(self):
        # self.assertMultiLineEqual (main.find_change('//+КХ Пашков_Д @ aaaaaa //-КХ Пашков_Д @ sdsdsd //+КХ Пашков_A @ bbbbb //-КХ Пашков_A @ '),
        # ['aaaaaa','bbbbb'])
      #  self.assertEqual (main.find_change('//+КХ_Пашков_Д_# aaaaaa //-КХ_Пашков_Д_# sdsdsd '),' aaaaaa ')
      #  self.assertEqual (main.find_change('//+КХ_Пашков_Д_# aaaaaa //-КХ_Пашков_Д_# sdsdsd //+КХ_Пашков_Д_24# bbb //-КХ_Пашков_Д_24# '),' bbb ')
        self.assertEqual (main.find_change('//+КХ_1_# aaaaaa //+КХ_24_# xx //-КХ_1_# sdsdsd //-КХ_24_# '),' aaaaaa //+КХ_24_# xx xx //-КХ_1_# sdsdsd ')
    
        
if __name__ == '__main__':
    unittest.main()