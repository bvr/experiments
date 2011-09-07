As such, XSLT is ill-suited for string processing. With XSLT 2.0, things get
better since more string functions are available, and sequence-based operations
are possible.

In XSLT 1.0 (which is still the most portable version to write code for),
character-by-character string processing can only be achieved through
recursion. For the fun of it, this:

    <xsl:output method="text" />

    <xsl:variable name="CRLF" select="'&#13;&#10;'" />

    <xsl:template match="/mytag">
      <!-- flip string -->
      <xsl:call-template name="reverse-string">
        <xsl:with-param name="s" select="string(.)" />
      </xsl:call-template>
      <xsl:value-of select="$CRLF" />

      <!-- vertical string -->
      <xsl:call-template name="vertical-string">
        <xsl:with-param name="s" select="string(.)" />
      </xsl:call-template>
    </xsl:template>

    <xsl:template name="reverse-string">
      <xsl:param name="s" select="''" />

      <xsl:variable name="l" select="string-length($s)" />

      <xsl:value-of select="substring($s, $l, 1)" />

      <xsl:if test="$l &gt; 0">
        <xsl:call-template name="reverse-string">
          <xsl:with-param name="s" select="substring($s, 1, $l - 1)" />
        </xsl:call-template>
      </xsl:if>
    </xsl:template>

    <xsl:template name="vertical-string">
      <xsl:param name="s" select="''" />

      <xsl:variable name="l" select="string-length($s)" />

      <xsl:value-of select="concat(substring($s, 1, 1), $CRLF)" />

      <xsl:if test="$l &gt; 0">
        <xsl:call-template name="vertical-string">
          <xsl:with-param name="s" select="substring($s, 2, $l)" />
        </xsl:call-template>
      </xsl:if>
    </xsl:template>

Produces:

    ataD modnaR
    R
    a
    n
    d
    o
    m

    D
    a
    t
    a

EDIT: To be clear: I do not endorse *actual use* of the above code sample in
any way. Presentational issues should by all means be solved in the
presentation layer. The above will work, but char-by-char recursion is among
the most inefficient ways to do string processing, and unless you have no other
choice, avoid string processing in XSLT.
