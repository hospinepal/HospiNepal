var $AutoTextComoleteList = [];

function richtextformat(command, value) {
  document.execCommand(command, false, value);
}

function numcheck(e, value) {
  var unicode = e.charCode ? e.charCode : e.keyCode;
  if (value.indexOf(".") != -1)
    if (unicode == 46) return false;
  if (unicode != 8)
    if ((unicode < 48 || unicode > 57) && unicode != 46) return false;
}

function setCookie(name,value,days) {
  var expires = "";
  if (days) {
    var date = new Date();
    date.setTime(date.getTime() + (days*24*60*60*1000));
    expires = "; expires=" + date.toUTCString();
  }
  document.cookie = name + "=" + (value || "")  + expires + "; path=/";
}

function ExportToExcel(TableID,type, fn, dl) {
  var elt = document.getElementById(TableID);
  var wb = XLSX.utils.table_to_book(elt, { sheet: "sheet1" });
  return dl ?
  XLSX.write(wb, { bookType: type, bookSST: true, type: 'base64' }):
  XLSX.writeFile(wb, fn || ('MySheetName.' + (type || 'xlsx')));
}

function html2pdfdocs(xoutput, xpapsize, xorient, xtopmargin, xleftmargin, xbottommargin, xrightmargin) {
  // Get the element.
  var element = document.getElementById('printable@report');

  // Generate the PDF.
  html2pdf().from(element).set({
      margin: [xtopmargin, xleftmargin, xbottommargin, xrightmargin],
      filename: xoutput,
      html2canvas: { scale: 1 },
      jsPDF: {orientation: xorient, unit: 'mm', format: xpapsize, compressPDF: false}
  }).save();
}

// autocomplete for textarea
function textautocomplete(id, idx) {

  var tributeAttributes = {
    autocompleteMode: true,
    noMatchTemplate: "",
    values: $AutoTextComoleteList,

    menuItemTemplate: function(item) {
      return item.string;
    }
  };

  var tributeAutocompleteTestArea = new Tribute(
    Object.assign(
      {
        menuContainer: document.getElementById( idx )
      },
      tributeAttributes
    )
  );
  tributeAutocompleteTestArea.attach(
    document.getElementById( id )
  );
}

// autocomplete for contenteditable div
function htmlautocomplete(id, idx) {

  var tributeAttributes = {
    autocompleteMode: true,
    noMatchTemplate: "",
    values: $AutoTextComoleteList,
    selectTemplate: function(item) {
      if (typeof item === "undefined") return null;
      if (this.range.isContentEditable(this.current.element)) {
        return (
          '<span contenteditable="false"><a>' +
          item.original.key +
          "</a></span>"
        );
      }

      return item.original.value;
    },
    menuItemTemplate: function(item) {
      return item.string;
    }
  };
  var tributeAutocompleteTest = new Tribute(
    Object.assign(
      {
        menuContainer: document.getElementById( idx )
      },
      tributeAttributes
    )
  );
  tributeAutocompleteTest.attach(
    document.getElementById(id)
  );

}

function openFullscreen() {
  var elem = document.documentElement;
  if (elem.requestFullscreen) {
    elem.requestFullscreen();
    } else if (elem.webkitRequestFullscreen) { /* Safari */
    elem.webkitRequestFullscreen();
    } else if (elem.msRequestFullscreen) { /* IE11 */
    elem.msRequestFullscreen();
  }
}

function closeFullscreen() {
  if (document.exitFullscreen) {
    document.exitFullscreen();
    } else if (document.webkitExitFullscreen) { /* Safari */
    document.webkitExitFullscreen();
    } else if (document.msExitFullscreen) { /* IE11 */
    document.msExitFullscreen();
  }
}

function canvasDownload (target, type) {
  let canvas = document.getElementById(target);
  let anchor = document.createElement("a");
  anchor.download = "download." + type;
  anchor.href = canvas.toDataURL("image/" + type);
  anchor.click();
  anchor.remove();
}

/*
 *  Copyright (c) 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree.
 */

function StartVideoCapture() {
  var constraints = { audio: false, video:true };
  navigator.mediaDevices.getUserMedia(constraints).then(function(mediaStream) {
      var video = document.querySelector('video');
      video.srcObject = mediaStream;
      video.onloadedmetadata = function(e) {
        video.play();
      };
  })
  .catch(function(err) { console.log(err.name + ": " + err.message); });
}

function TakeCamShot() {
  var video = document.querySelector('video');
  var canvas = window.canvas = document.querySelector('canvas');
  canvas.width = video.videoWidth;
  canvas.height = video.videoHeight;
  canvas.getContext('2d').drawImage(video, 0, 0, canvas.width, canvas.height);
}

function changeScreenMode() {
  if( $( "body" ).hasClass( "dark" )) {
    $( "body" ).removeClass( "dark" );
    } else {
    $( "body" ).addClass( "dark" );
  }
}
