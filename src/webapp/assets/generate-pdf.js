// Function to generate PDF from the HTML content
function generatePDF() {
    const element = document.documentElement;
    const opt = {
        margin: 1,
        filename: 'Street_Croquet_Official_Rules.pdf',
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2 },
        jsPDF: { unit: 'in', format: 'letter', orientation: 'portrait' }
    };

    // Remove the page number before generating PDF
    const pageNumber = document.querySelector('.page-number');
    if (pageNumber) {
        pageNumber.style.display = 'none';
    }

    // Generate PDF
    html2pdf().set(opt).from(element).save().then(() => {
        // Restore page number after PDF generation
        if (pageNumber) {
            pageNumber.style.display = 'block';
        }
    });
}

// Add html2pdf.js library
const script = document.createElement('script');
script.src = 'https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js';
document.head.appendChild(script);

// Generate PDF when the page loads
script.onload = generatePDF; 