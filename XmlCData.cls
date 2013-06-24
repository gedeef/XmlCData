public class XmlCData
{
    public static String lt;    //String replacement for <
    public static String gt;    //string replacement for >
    //possible replacement strings
    private static List<String> slt = '{|(|#|@|$|%|!|:|;|,|lt|LowerThan|XmlCDataLowerThan'.split('\\|', 0);
    private static List<String> sgt = '}|)|#|@|$|%|!|:|;|,|gt|GreaterThan|XmlCDataGreaterThan'.split('\\|', 0);

   
    
    //find the best replacement string (not present in xml string). If none, build it with an as much as necessary repeated char
    public static void setReplacementStrings(String XmlString)
    {
        lt=gt=null;
        for (String l : slt)
        {
            if (XmlString.indexOf(l)==(-1))
            {
                lt=l;
                break;
            }
        }
        if (lt==null)
        {
            String l2 = '{{';
            while (XmlString.indexOf(l2)!=(-1))
                l2+='{';
            lt=l2;
        }
        for (String g : sgt)
        {
            if ((XmlString.indexOf(g)==(-1)) && (g!=lt))
            {
                gt=g;
                break;
            }
        }
        if (gt==null)
        {
            String g2 = '}}';
            while (XmlString.indexOf(g2)!=(-1))
                g2+='}';
            gt=g2;
        }
    }

    //transform the cdata sections into regular nodes containing escaped text
    public static String addCDataNodes(String XmlString)
    {
        setReplacementStrings(XmlString);
        Pattern CDataSectionPattern = Pattern.compile('<!\\[CDATA\\[(.*?)\\]\\]>');
        Matcher m = CDataSectionPattern.matcher(XmlString);
        while (m.find())
        {
            XmlString = XmlString.substring(0, m.start()) +
                '<CDataSection lt="'+lt+'" gt="'+gt+'">'+ +
                m.group(1).replace('<', lt).replace('>',gt) +
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
            return cdata.getText().replace(cdata.getAttribute('lt', null), '<').replace(cdata.getAttribute('gt', null), '>');
        else return node.getText();
    }
}
