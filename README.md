XmlCData
========

adds support to CDATA to Apex Dom.Document


The Apex Dom.Document ignores CDATA sections, and fails to parse the document if such a section contains '<' or '>'.

The idea is to transform the CDATA section in a node named... CDataSection, and to escape '<' and '>'

To use it, just load XmlCData.addCDataNodes(yourXmlString) into your Dom.Document, and read the text content of nodes with XmlCData.text(yourNode) instead of yourNode.getText()

Notice that this will add nodes to your doc so depending on how you coded, this could cause your code to fail unless you modify it.
