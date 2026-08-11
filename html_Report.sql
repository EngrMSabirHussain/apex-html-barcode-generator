DECLARE
    l_html CLOB;
BEGIN

    l_html := q'[
<style>
* { 
  box-sizing: border-box; 
}
html, body {
  margin: 0 !important;
  padding: 0 !important;
}
.page {
  width: 4in;
  margin: 0 !important;
  padding: 0 !important;
}
.label {
  width: 4in;
  height: 2.6in;
  padding: 6px;
  margin: 0 !important;
  overflow: hidden;
  background: #fff;
}
/* Inserts page breaks only between records */
.label:not(:last-child) {
  page-break-after: always;
  break-after: always;
}
.barcode {
  text-align: center;
  margin-bottom: 4px;
}
.barcode img {
  width: 320px;
  height: 60px;
}
.barcode_no {
  text-align: center;
  font-size: 14px;
  font-weight: bold;
  margin-bottom: 5px;
}
table {
  width: 100%;
  margin: 3;
  border-collapse: collapse;
}
td {
  border: 1px solid #000;
  padding: 3px;
  font-size: 11px;
}
.title {
  width: 22%;
  font-weight: bold;
  background: #f2f2f2;
}

/* Chrome-Safe APEX Isolation Override */
@media print {

    @page{
        size:4in 2.6in;
        margin:0;
    }

    /* Force APEX structural containers to stop rendering text and sizing */
  .t-Body, .t-Body-main, .t-Body-content, .t-Body-contentInner {
    display: block !important;
    padding: 0 !important;
    margin: 0 !important;
    height: auto !important;
    min-height: 0 !important;
  }
  
  /* Completely hide standard APEX layouts */
  .t-Header, .t-Body-nav, .t-Footer, .t-BreadcrumbRegion, 
  .t-ButtonRegion, .t-Region-header, #apexDevToolbar {
    display: none !important;
  }

    html,body{
        margin:0 !important;
        padding:0 !important;
    }

    .page{
        width:4in;
        margin:0 !important;
        padding:0 !important;
    }

    .label{
        width:4in;
        height:2.6in;
        margin:0 !important;
        padding:6px;
        box-sizing:border-box;
    }

    .t-Header,
    .t-Body-nav,
    .t-Footer,
    .t-BreadcrumbRegion,
    .t-ButtonRegion,
    .t-Region-header,
    #apexDevToolbar{
        display:none !important;
    }
}
</style>



<div class="page">
]';

    FOR r IN
    (
        SELECT H.H_ID,
               SYSDATE DOC_DATE,
               CASE
                   WHEN LENGTH(H.DESCRIPTION) > 240
                   THEN SUBSTR(H.DESCRIPTION,1,240)||'...'
                   ELSE H.DESCRIPTION
               END DESCRIPTION,
               H.SHORT_CODE,
               L.BARCODE_ID,
               SUBSTR(TO_CHAR(L.BARCODE_ID), -4) AS SHORT_BARCODE_ID,
               L.QTY
        FROM M6_WASTE_BAG_H H
             JOIN M6_WASTE_BAG_L L
               ON H.H_ID=L.H_ID
        WHERE H.H_ID=:P5_H_ID
        ORDER BY L.BARCODE_ID
    )
    LOOP

        l_html := l_html ||

        '<div class="label">

            <div class="barcode">

                <svg class="my-barcode" data-barcode="' ||
                    r.barcode_id ||
                '"></svg>

            </div>

            <div class="barcode_no">'||
                r.SHORT_CODE||r.SHORT_BARCODE_ID||
            '</div>

            <table>

                <tr>
                    <td class="title">Document #</td>
                    <td>'||r.h_id||'</td>
                </tr>

                <tr>
                    <td class="title">Creation Date</td>
                    <td>'||TO_CHAR(r.doc_date,'DD-MON-YYYY HH12:MI AM')||'</td>
                </tr>

                <tr>
                    <td class="title">Description</td>
                    <td>'||NVL(r.description,'-')||'</td>
                </tr>

                <tr>
                    <td class="title">Quantity (KG)</td>
                    <td>'||r.qty||'</td>
                </tr>

            </table>

        </div>';

    END LOOP;

    l_html := l_html || '</div>';

    RETURN l_html;

END;
