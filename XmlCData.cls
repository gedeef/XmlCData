public class XmlCData
{
    public static String lt;    //String replacement for <
    public static String gt;    //string replacement for >
    //possible replacement strings
    private static List<String> slt = '{|(|#|@|$|%|!|:|;|,|lt|LowerThan|XmlCDataLowerThan'.split('\\|', 0);
    private static List<String> sgt = '}|)|#|@|$|%|!|:|;|,|gt|GreaterThan|XmlCDataGreaterThan'.split('\\|', 0);

   
    
    //find the best replacement string (not present in xml string). If none, build it with an as much as necessary repeated char
    //this method should not be used if you intend to modify the content of your xml document because you can't be sure that the replacement string for < or > will not be added for itself
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
    //ltReplace and gtReplace must be chosen carefully : they must not exist neither now nor later in the XmlString or Dom.document. Use a complicated string to be sure, like ##:CDATALowerThan:## i.e.
    //if any of ltReplace or gtReplace is null, the replacement strings will be defined by setReplacementStrings
    public static String addCDataNodes(String XmlString, String ltReplace, String gtReplace)
    {
        if ((ltReplace==null) or (gtReplace==null))
            setReplacementStrings(XmlString);   //only for a read-only purpose document !
        else
        {
            /* @todo : check that ltReplace and gtReplace are not contained in XmlString, if yes, raise an error */
            lt=ltReplace; gt = gtReplace;
        }
        Pattern CDataSectionPattern = Pattern.compile('<!\\[CDATA\\[(.*?)\\]\\]>');
        Matcher m = CDataSectionPattern.matcher(XmlString);
        while (m.find())
        {
            XmlString = XmlString.substring(0, m.start()) +
                '<CDataSection lt="'+lt+'" gt="'+gt+'">'+
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
