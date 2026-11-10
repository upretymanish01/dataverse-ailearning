# Converts a QLS-styled HTML plan to .docx (and optionally PDF) using Microsoft Word.
# Windows PowerShell 5.1 + Word only; nothing to install.
# Keep this file ASCII-only: PowerShell 5.1 misreads UTF-8 without a BOM.
#
# Usage:
#   & .\convert-to-word.ps1 -Html "C:\full\path\plan.html" -Docx "C:\full\path\Plan.docx" `
#       -Pdf "C:\full\path\plan.pdf" -HeaderTitle "MBA Reconciliation - Delivery Plan"
param(
    [Parameter(Mandatory)] [string]$Html,
    [Parameter(Mandatory)] [string]$Docx,
    [string]$Pdf,
    [string]$HeaderTitle = "Delivery Plan"
)
$ErrorActionPreference = 'Stop'
$dot = [char]0x00B7

$word = New-Object -ComObject Word.Application
$word.Visible = $false
try {
    $doc = $word.Documents.Open($Html, $false, $true)
    $doc.ActiveWindow.View.Type = 3                     # print layout

    # A4 portrait, 2.54 cm margins
    $ps = $doc.PageSetup
    $ps.PaperSize = 7
    $ps.TopMargin = 72; $ps.BottomMargin = 72; $ps.LeftMargin = 72; $ps.RightMargin = 72

    # Tables: full width, tight rows, repeat header row (table 1 = document control, no header)
    $i = 0
    foreach ($t in $doc.Tables) {
        $i++
        $t.PreferredWidthType = 2; $t.PreferredWidth = 100
        if ($i -gt 1) { $t.Rows.Item(1).HeadingFormat = -1 }
        $t.Range.ParagraphFormat.SpaceBefore = 0
        $t.Range.ParagraphFormat.SpaceAfter = 0
        $t.TopPadding = 2; $t.BottomPadding = 2
    }

    # Headings stay with the content that follows them
    foreach ($p in $doc.Paragraphs) {
        if ($p.Style.NameLocal -like 'Heading*') { $p.KeepWithNext = -1 }
    }

    $sec = $doc.Sections.Item(1)

    # Header: QLS . <title>, 9 pt grey, bottom border #BFB3D6
    $hdr = $sec.Headers.Item(1).Range
    $hdr.Text = "QLS $dot $HeaderTitle"
    $hdr.Font.Name = "Calibri"; $hdr.Font.Size = 9; $hdr.Font.Color = 0x555555
    $hdr.ParagraphFormat.Borders.Item(-3).LineStyle = 1
    $hdr.ParagraphFormat.Borders.Item(-3).Color = 0xD6B3BF   # BGR of #BFB3D6

    # Footer: QLS . Internal (left), Page X of Y (right)
    $ftr = $sec.Footers.Item(1).Range
    $ftr.Text = "QLS $dot Internal`tPage PGX of PGY"
    $ftr.Font.Name = "Calibri"; $ftr.Font.Size = 9; $ftr.Font.Color = 0x555555
    $ftr.ParagraphFormat.TabStops.ClearAll()
    $null = $ftr.ParagraphFormat.TabStops.Add(451.3, 2)      # right tab at text width
    foreach ($pair in @(@('PGX', 33), @('PGY', 26))) {      # wdFieldPage, wdFieldNumPages
        $r = $sec.Footers.Item(1).Range
        if ($r.Find.Execute($pair[0])) { $null = $r.Fields.Add($r, $pair[1]) }
    }

    $doc.SaveAs2($Docx, 16)                                  # wdFormatDocumentDefault (.docx)
    if ($Pdf) { $doc.ExportAsFixedFormat($Pdf, 17) }         # wdExportFormatPDF
    $doc.Close($false)
    "saved: $Docx"
} finally {
    $word.Quit()
}
