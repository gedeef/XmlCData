@isTest
public class testXmlCData {
  
    @isTest
    public static void test()
    {
        String xml = '<root><node><![CDATA[some text with some < < and some > for test purpose]]></node><othernode>with nothing special</othernode><thirdNode><![CDATA[another test text]]></thirdNode></root>';
        Dom.Document doc = new Dom.Document();
        doc.load(XmlCData.addCDataNodes(xml));
        System.assertEquals(doc.toXmlString().indexOf('<!CDATA['), -1);
        System.assertEquals(doc.toXmlString().indexOf('text with some <'), -1);
        System.assertEquals((doc.toXmlString().indexOf('text with some')!=-1), true);
        Dom.XmlNode root = doc.getRootElement();
        for (Dom.XmlNode n : root.getChildElements())
            System.debug(XmlCData.text(n));
        
        String unlucky = '{(#@$%!:;ltXmlCDataLowerThan}),gtXmlCDataGreaterThan';
        XmlCData.setReplacementStrings(unlucky);
        System.assertEquals(XmlCData.lt, '{{');
        System.assertEquals(XmlCData.gt, '}}');
    }
}
