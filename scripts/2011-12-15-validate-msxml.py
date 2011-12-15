"""Validate an XML file (1st param) against an XML schema
(2nd param), using MSXML and comtypes.

Copyright 2008 (c) Andre Burgaud
MIT License

Version 1.0

$Id: msxml_schema_val.py 445 2008-01-27 05:13:47Z andre $
"""

from comtypes.client import CreateObject
from _ctypes import COMError
import os
import sys

FORMAT_ERROR = """\
%s: Validation Error
- Error Code : %s
- Reason     : %s
- Character  : %s
- Line       : %s
- Column     : %s
- Source     : %s
               %s"""

FORMAT_SUCCESS = """\
Namespace : %s
Schema    : %s
Valid XML : %s
"""

# MSXML versions to use
MSXML_VERSIONS = [6, 4]
MSXML_DOM = 'Msxml2.DOMDocument.%d.0'
MSXML_SCHEMAS = 'Msxml2.XMLSchemaCache.%d.0'

def find(xml_file, xsd_file):
  """Validate existence of files."""
  for xfile in (xml_file, xsd_file):
    if not os.path.exists(xfile):
      print 'File %s not found...' % xfile
      return False
  return True

class MsXmlValidator:
  """Encapsulate some basic MXSML funcionalities to validate an XML
  file against an XML Schema.
  """

  def __init__(self):
    """Instantiate DOMDocument and XMLSchemaCache."""
    self.dom = self.create_dom()
    self.schemas = self.create_schemas()
    self.msxml_version = 0

  def create_dom(self):
    """Create and return a DOMDocument."""
    versions = MSXML_VERSIONS
    versions.sort(reverse=True)
    dom = None
    for version in versions:
      try:
        prog_id = MSXML_DOM % version
        dom = CreateObject(prog_id)
        self.msxml_version = version
        print 'MSXML version %s: OK' % version
        break
      except WindowsError, msg:
        print 'Error:', msg
        print 'MSXML version %d: problem on this system' % version
    if not dom:
      print 'No compatible MSXML versions found on this system'
      sys.exit()
    dom.async = 0 # false
    return dom

  def create_schemas(self):
    """Create and return a Schema Cache."""
    schemas = CreateObject(MSXML_SCHEMAS % self.msxml_version)
    return schemas

  def get_namespace(self, xsd_file):
    """Extract targetNamespace, if any,  from XML schema."""
    namespace = ''
    self.dom.load(xsd_file)
    self.dom.setProperty("SelectionLanguage", "XPath")
    path = "/*/@targetNamespace"
    node = self.dom.documentElement.selectSingleNode(path)
    if node:
      namespace = node.text
    return namespace

  def add_schema(self, namespace, xsd_file):
    """Add schema and namespace to Schema Cache."""
    try:
      self.schemas.add(namespace, xsd_file)
    except COMError, msg:
      print 'Error in XML Schema: %s' % xsd_file
      print msg
      sys.exit()
    self.dom.schemas = self.schemas

  def validate_xml_file(self, xml_file, xsd_file):
    """Validate XML file against XML Schema file."""
    if not find(xml_file, xsd_file):
      sys.exit()
    namespace = self.get_namespace(xsd_file)
    self.add_schema(namespace, xsd_file)
    if self.dom.load(xml_file):
      print FORMAT_SUCCESS % (namespace, xsd_file, xml_file)
    else:
      error = self.dom.parseError
      print FORMAT_ERROR % (xml_file,
                             error.errorCode,
                             error.reason.strip(),
                             error.filepos,
                             error.line,
                             error.linepos,
                             error.srcText,
                             " " * (error.linepos - 1) + '^')

def main():
  """Handle paramaters, create Validator and invoke validation."""
  if len(sys.argv) &lt; 3:
    print 'Usage: %s xml_file xsd_file' % sys.argv[0]
    sys.exit()
  validator = MsXmlValidator()
  xml_file, xsd_file = sys.argv[1], sys.argv[2]
  validator.validate_xml_file(xml_file, xsd_file)

if __name__ == '__main__':
  main()
