# Oracle APEX - Html Barcode Report

A simple **Oracle APEX Barcode Generator** that creates Code 128 barcodes directly in the browser using **JsBarcode**, without calling an external barcode generation API.

## 🚀 Features

* Generate **Code 128** barcodes
* No external barcode API required
* Barcode generated directly in the browser
* Works with Oracle APEX Reports
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
        width: 2,
        height: 60,
        displayValue: false,
        margin: 0
    });

    el.style.width = "320px";
    el.style.height = "60px";
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

```html
<svg class="my-barcode"
     data-barcode="#BARCODE_ID#"></svg>
```

### 3. Generate Barcode

Add the following JavaScript after the report is rendered:

```javascript
document.querySelectorAll('.my-barcode').forEach(function (el) {

    JsBarcode(el, el.dataset.barcode, {
        format: "CODE128",
        width: 2,
        height: 60,
        displayValue: false,
        margin: 0
    });

    el.style.width = "320px";
    el.style.height = "60px";
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
