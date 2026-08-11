# Oracle APEX - Html Barcode Report

A simple **Oracle APEX Barcode Generator** that creates Code 128 barcodes Report(4'x 3') directly in the browser using **JsBarcode**, without calling an external barcode generation API.

## 🚀 Features

* Generate **Code 128** barcodes
* No external barcode API required
* Barcode generated directly in the browser
* Supports dynamic barcode values
* Supports custom barcode width and height
* Suitable for printing labels
* Can be used with APEX HTML Reports
* Lightweight and easy to customize

## 🛠️ Technologies

* Oracle APEX
* Oracle Database
* JavaScript
* HTML
* CSS
* JsBarcode
* SQL

## 📌 How It Works

The barcode value is returned from the Oracle APEX SQL query and passed to an HTML `<svg>` element.

Example:

```html
<svg class="my-barcode" data-barcode="#BARCODE_ID#"></svg>
```

JavaScript then generates the Code 128 barcode:

```javascript
document.querySelectorAll('.my-barcode').forEach(function (el) {

    JsBarcode(el, el.dataset.barcode, {
        format: "CODE128",
        width: 3.5,
        height: 60,
        displayValue: false,
        margin: 0
    });

});
```

## 🗄️ Example SQL

```sql
SELECT H.H_ID,
       SYSDATE AS DOC_DATE,
       CASE
           WHEN LENGTH(H.DESCRIPTION) > 240
           THEN SUBSTR(H.DESCRIPTION, 1, 240) || '...'
           ELSE H.DESCRIPTION
       END AS DESCRIPTION,
       H.SHORT_CODE,
       SUBSTR(TO_CHAR(L.BARCODE_ID), -4) AS BARCODE_ID,
       L.QTY
FROM M6_WASTE_BAG_H H
JOIN M6_WASTE_BAG_L L
    ON H.H_ID = L.H_ID
WHERE H.H_ID = :P5_H_ID
ORDER BY L.BARCODE_ID;
```

## 📦 APEX Setup

### 1. Add JsBarcode

Download the JsBarcode library and upload it to:

**Shared Components → Static Application Files**

Add:

```text
JsBarcode.all.min.js
```

Then include it in:

**Page → JavaScript → File URLs**

```text
#APP_FILES#JsBarcode.all.min.js
```

### 2. Create HTML Report

Use the following HTML expression:


<details>
<summary>📄 View HTML Report Code</summary>

```html
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

```
</details>

### 3. Generate Barcode

Add the following JavaScript:
    **Page → JavaScript → Function and Global Variable Declaration**

```javascript
document.querySelectorAll('.my-barcode').forEach(function (el) {

    JsBarcode(el, el.dataset.barcode, {
        format: "CODE128",
        width: 3.5,
        height: 60,
        displayValue: false,
        margin: 0
    });
});
```

## 🖨️ Printing

The generated barcode is an SVG element, so it can be printed directly from the browser without requesting an image from an external server.

This makes the solution useful for:

* Product labels
* Waste bag labels
* Inventory labels
* Warehouse labels
* Packing labels
* Barcode reports
* APEX printing applications

## 🔐 Why No API?

Instead of generating a barcode through an external URL such as:

```text
https://bwipjs-api.metafloor.com/
```

this solution generates the barcode locally in the browser.

### Benefits

* No API dependency
* No internet request for barcode generation
* Faster barcode generation
* Better control over printing
* Works with internal/private APEX applications
* Avoids external API availability issues

## 📷 Screenshot

Add your report screenshot here:

```text
screenshots/barcode-report.png
```

Example:

![Oracle APEX Barcode Report](screenshots/barcode-report.png)

## ⭐ Support

If you find this project useful, please consider giving the repository a ⭐ star.

It helps others discover the solution and supports me in sharing more Oracle APEX and Oracle Database solutions with the community.

## 👨‍💻 Author

**Sabir Hussain**

Oracle APEX Developer | Oracle Database | PL/SQL | REST APIs | ORDS
