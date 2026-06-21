/*****************************************************************
 WHO AFRO Surveillance Support Dashboard
 Author: Joao Muianga
 Description:
 Handles page navigation and smooth scrolling.
*****************************************************************/


/* ============================================================
   SMOOTH SCROLL TO SECTION
============================================================ */

function scrollToSection(sectionId) {

    const section = $("#" + sectionId);

    if (section.length) {

        $("html, body").animate({
            scrollTop: section.offset().top - 20
        }, 500);

    }

}


/* ============================================================
   SIDEBAR NAVIGATION
============================================================ */

$(document).on("click", "#goto_overview", function () {

    scrollToSection("overview_section");

});

$(document).on("click", "#goto_map", function () {

    scrollToSection("map_section");

});

$(document).on("click", "#goto_ranking", function () {

    scrollToSection("ranking_section");

});

$(document).on("click", "#goto_profile", function () {

    scrollToSection("profile_section");

});

$(document).on("click", "#goto_recommendations", function () {

    scrollToSection("recommendations_section");

});

$(document).on("click", "#goto_about", function () {

    scrollToSection("about_section");

});


/* ============================================================
   ACTIVE SIDEBAR MENU HIGHLIGHT
============================================================ */

$(document).on("click", ".sidebar-link", function () {

    $(".sidebar-link").removeClass("active-menu");

    $(this).addClass("active-menu");

});


/* ============================================================
   OPTIONAL: SCROLL TO TOP BUTTON
============================================================ */

$(document).ready(function () {

    $("body").append(
        '<button id="scrollTopBtn" title="Go to top">↑</button>'
    );

    $("#scrollTopBtn").css({
        display: "none",
        position: "fixed",
        bottom: "30px",
        right: "30px",
        zIndex: 999,
        border: "none",
        outline: "none",
        backgroundColor: "#052B57",
        color: "white",
        cursor: "pointer",
        padding: "10px 14px",
        borderRadius: "50%",
        fontSize: "18px",
        boxShadow: "0 2px 8px rgba(0,0,0,0.3)"
    });

});


$(window).scroll(function () {

    if ($(this).scrollTop() > 300) {

        $("#scrollTopBtn").fadeIn();

    } else {

        $("#scrollTopBtn").fadeOut();

    }

});


$(document).on("click", "#scrollTopBtn", function () {

    $("html, body").animate({
        scrollTop: 0
    }, 600);

});