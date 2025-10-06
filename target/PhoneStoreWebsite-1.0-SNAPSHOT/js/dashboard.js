/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// Toggle Sidebar
const wrapper = document.getElementById("wrapper");
document.getElementById("menu-toggle").onclick = () => {
    wrapper.classList.toggle("toggled");
};

// ApexCharts Line Chart
const visitorOptions = {
    chart: { type: 'area', height: 250, toolbar: { show: false } },
    series: [{
        name: 'Visitors',
        data: [30, 40, 35, 50, 49, 60, 70]
    }],
    colors: ['#4f8ef7'],
    fill: { type: 'gradient', gradient: { shadeIntensity: 1, opacityFrom: 0.4, opacityTo: 0.1 } },
    xaxis: { categories: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'] }
};
new ApexCharts(document.querySelector("#visitorChart"), visitorOptions).render();

// ApexCharts Bar Chart
const incomeOptions = {
    chart: { type: 'bar', height: 250, toolbar: { show: false } },
    series: [{ name: 'Income', data: [76, 85, 65, 90, 70, 60, 80] }],
    colors: ['#47c9a2'],
    plotOptions: { bar: { borderRadius: 5, columnWidth: '40%' } },
    xaxis: { categories: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'] }
};
new ApexCharts(document.querySelector("#incomeChart"), incomeOptions).render();


