let currentImage = 0;
const images = [1, 2, 3, 4, 5];

function updateImage() {
  const mainImage = document.getElementById('mainImage');
  mainImage.classList.remove('fade-in');
  void mainImage.offsetWidth; // reset animation
  mainImage.classList.add('fade-in');
  mainImage.textContent = '🖼️ ' + images[currentImage];
  document.querySelectorAll('.thumb').forEach((t, i) => {
    t.classList.toggle('active', i === currentImage);
  });
}

function nextImage() {
  currentImage = (currentImage + 1) % images.length;
  updateImage();
}

function prevImage() {
  currentImage = (currentImage - 1 + images.length) % images.length;
  updateImage();
}

function selectImage(index) {
  currentImage = index;
  updateImage();
}

//setInterval(nextImage, 3000);


// Select Version + Update Price
function selectVersion(btn) {
  document.querySelectorAll('.option').forEach(b => b.classList.remove('selected'));
  btn.classList.add('selected');

}

// Select Color
function selectColor(div) {
  document.querySelectorAll('.color').forEach(c => c.classList.remove('selected'));
  div.classList.add('selected');
}