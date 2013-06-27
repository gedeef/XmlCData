public class XmlCData           //not tested yet
{
    //transform the cdata sections into regular nodes containing escaped text
    public static String addCDataNodes(String XmlString, String ltReplace, String gtReplace)
    {
        Pattern CDataSectionPattern = Pattern.compile('<!\\[CDATA\\[(.*?)\\]\\]>');
        Matcher m = CDataSectionPattern.matcher(XmlString);
        while (m.find())    //could be simplified with a replaceAll ? @todo
        {
            XmlString = XmlString.substring(0, m.start()) +
                '<CDataSection>'+
                m.group(1).escapeXml() +
                '</CDataSection>'
                +  XmlString.substring( m.end());
            m = CDataSectionPattern.matcher(XmlString);
        }
        return XmlString;
    }
    
    //read a node like getText
    public static String text(Dom.XmlNode node)
    {
        Dom.XmlNode cdata = node.getChildElement('CDataSection', null);
        if (cdata != null)
            return cdata.getText().unescapeXml();
        else return node.getText();
    }
}
