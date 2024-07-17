
let mediaRecorder;
let recordedBlobs;

const codecPreferences = document.getElementById('cmbCodec');

const errorMsgElement = document.getElementById('pnlError');
const recordedVideo = document.getElementById('sRecVideo');
const recordButton = document.getElementById('btnRecord');
function initiateVideo() {
  if (recordButton.textContent === 'Start Recording') {
    startRecording();
    } else {
    stopRecording();
    recordButton.textContent = 'Start Recording';
    playButton.disabled = false;
    downloadButton.disabled = false;
    codecPreferences.disabled = false;
  }
};

recordButton.onclick = initiateVideo;

const playButton = document.getElementById('btnPlay');
playButton.addEventListener('click', () => {
    const mimeType = 'video/webm;codecs=vp8,opus'; /*! codecPreferences.options[codecPreferences.selectedIndex].value.split(';', 1)[0];*/
    const superBuffer = new Blob(recordedBlobs, {type: mimeType});
    recordedVideo.src = null;
    recordedVideo.srcObject = null;
    recordedVideo.src = window.URL.createObjectURL(superBuffer);
    recordedVideo.controls = true;
    recordedVideo.play();
});

const downloadButton = document.getElementById('btnDown');
downloadButton.addEventListener('click', () => {
    const blob = new Blob(recordedBlobs, {type: 'video/webm'});
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.style.display = 'none';
    a.href = url;
    a.download = 'test.webm';
    document.body.appendChild(a);
    a.click();
    setTimeout(() => {
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
    }, 100);
});

function handleDataAvailable(event) {
  console.log('handleDataAvailable', event);
  if (event.data && event.data.size > 0) {
    recordedBlobs.push(event.data);
  }
}

function getSupportedMimeTypes() {
  const possibleTypes = [
    'video/webm;codecs=vp9,opus',
    'video/webm;codecs=vp8,opus',
    'video/webm;codecs=h264,opus',
    'video/mp4;codecs=h264,aac',
  ];
  return possibleTypes.filter(mimeType => {
      return MediaRecorder.isTypeSupported(mimeType);
  });
}

function startRecording() {
  recordedBlobs = [];
  /*! const mimeType = codecPreferences.options[codecPreferences.selectedIndex].value;  */
  const mimeType = 'video/webm;codecs=vp8,opus'
  const options = {mimeType};

  try {
    mediaRecorder = new MediaRecorder(window.stream, options);
    } catch (e) {
    console.error('Exception while creating MediaRecorder:', e);
    return;
  }

  console.log('Created MediaRecorder', mediaRecorder, 'with options', options);
  recordButton.textContent = 'Stop Recording';
  playButton.disabled = true;
  downloadButton.disabled = true;
  codecPreferences.disabled = true;
  mediaRecorder.onstop = (event) => {
    console.log('Recorder stopped: ', event);
    console.log('Recorded Blobs: ', recordedBlobs);
  };
  mediaRecorder.ondataavailable = handleDataAvailable;
  mediaRecorder.start();
  console.log('MediaRecorder started', mediaRecorder);
}

function stopRecording() {
  mediaRecorder.stop();
}

function handleSuccess(stream) {
  recordButton.disabled = false;
  console.log('getUserMedia() got stream:', stream);
  window.stream = stream;

  const gumVideo = document.getElementById('sGumVideo');
  gumVideo.srcObject = stream;

  getSupportedMimeTypes().forEach(mimeType => {
      const option = document.createElement('option');
      option.value = mimeType;
      option.innerText = option.value;
      codecPreferences.appendChild(option);
  });
  codecPreferences.disabled = false;
}

async function init(constraints) {
  try {
    const stream = await navigator.mediaDevices.getUserMedia(constraints);
    handleSuccess(stream);
    } catch (e) {
  }
}

document.getElementById('btnStart').addEventListener('click', async () => {
    document.getElementById('btnStart').disabled = true;
    const hasEchoCancellation = document.getElementById('chkEcho').checked;
    const constraints = {
      audio: {
        echoCancellation: {exact: hasEchoCancellation}
      },
      video: {
        width: 1280, height: 720
      }
    };
    console.log('Using media constraints:', constraints);
    await init(constraints);
});
