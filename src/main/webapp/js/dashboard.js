// Sidebar toggle
const wrapper = document.getElementById("wrapper");
document.getElementById("menu-toggle").onclick = () => {
    wrapper.classList.toggle("toggled");
};

// Charts setup
const incomeChart = new ApexCharts(document.querySelector("#incomeChart"), {
    chart: { type: "area", height: 250, toolbar: { show: false } },
    series: [{ name: "Income", data: [] }],
    colors: ["#4f8ef7"],
    fill: { type: "gradient", gradient: { shadeIntensity: 1, opacityFrom: 0.4, opacityTo: 0.1 } },
    xaxis: { categories: [] },
    yaxis: {
        labels: {
            formatter: function (value) {
                return value + "m"; // Chia 1 triệu và thêm 'm'
            }
        },
        title: {
            text: "Income"
        }
    },
    title: { text: "Income by Month" }
});


const orderChart = new ApexCharts(document.querySelector("#orderChart"), {
    chart: {type: "bar", height: 250, toolbar: {show: false}, events: {
            dataPointSelection: (event, chartContext, config) => {
                const monthIndex = config.dataPointIndex + 1;
                const year = document.getElementById("yearSelect").value;
                console.log(`Income chart clicked: yearSelect=${monthIndex}, yearSelect=${year}`);

                // Gửi về servlet (GET)
                window.location.href = `${contextPath}/admin?action=dashboard&monthSelect=${monthIndex}&yearSelect=${year}`;

            },
        },
    },
    series: [{name: "Order", data: []}],
    colors: ["#47c9a2"],
    plotOptions: {bar: {borderRadius: 5, columnWidth: "40%"}},
    xaxis: {categories: []},
    title: {text: "Orders by Month"}
});

orderChart.render();
incomeChart.render();

function updateMonthlyChart(year) {
    const currentMonth = new Date().getMonth() + 1;
    const allMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    const months = year === new Date().getFullYear() ? allMonths.slice(0, currentMonth) : allMonths;

    const orderData = monthlyOrder.map(Number);
    const incomeData = monthlyIncome.map(Number);

    orderChart.updateOptions({
        series: [{name: "Order", data: orderData}],
        xaxis: {categories: months},
        title: {text: `Order by Month (${year})`}
    });

    incomeChart.updateOptions({
        series: [{name: "Income", data: incomeData}],
        xaxis: {categories: months},
        title: {text: `Income by Month (${year})`}
    });
}

// Render lần đầu
updateMonthlyChart(selectYear);
