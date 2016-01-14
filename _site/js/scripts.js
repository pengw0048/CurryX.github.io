!
function (e) {
    "use strict";

    function t() {
        if (e(".portfolio").length) {
            var t = e("#work-wrap").imagesLoaded(function () {
                t.isotope({
                    transitionDuration: "0.6s",
                    hiddenStyle: {
                        opacity: 0,
                        transform: "scale(0.1)"
                    },
                    visibleStyle: {
                        opacity: 1,
                        transform: "scale(1)"
                    }
                })
            });
            e(".portfolio #filters a").click(function () {
                e(".select-filter").removeClass("select-filter"), e(this).parent("li").addClass("select-filter");
                var t = e(this).attr("data-filter");
                return e("#work-wrap").isotope({
                    filter: t
                }), !1
            })
        }
    }
    function a(t) {
        var a = e(window).width();
        if (e(t).length && a >= 992) {
            var i = 0;
            e.each(e(t), function () {
                var t = parseInt(e(this).outerHeight());
                t > i && (i = t)
            }), e.each(e(t), function () {
                e(this).css("height", i + "px")
            })
        } else e(t).css("height", "")
    }
    function i() {
        if (e("#map").length) {
            var t, a = e("#map"),
                i = a.data("map-zoom"),
                s = a.data("map-latlng").split(",")[0],
                l = a.data("map-latlng").split(",")[1],
                n = a.data("map-marker"),
                r = parseInt(a.data("map-marker-size").split("*")[0]),
                o = parseInt(a.data("map-marker-size").split("*")[1]),
                p = a.find("h4").text(),
                d = a.find("p").text(),
                m = [{
                    featureType: "all",
                    stylers: [{
                        saturation: -100
                    }, {
                        gamma: .5
                    }]
                }],
                c = [{
                    featureType: "all",
                    stylers: [{
                        hue: "#0000b0"
                    }, {
                        invert_lightness: "true"
                    }, {
                        saturation: -30
                    }]
                }],
                f = [{
                    featureType: "all",
                    stylers: [{
                        hue: "#ff1a00"
                    }, {
                        invert_lightness: !0
                    }, {
                        saturation: -100
                    }, {
                        lightness: 33
                    }, {
                        gamma: .5
                    }]
                }],
                g = [{
                    stylers: [{
                        hue: "#ff61a6"
                    }, {
                        visibility: "on"
                    }, {
                        invert_lightness: !0
                    }, {
                        saturation: 40
                    }, {
                        lightness: 10
                    }]
                }],
                u = [{
                    featureType: "water",
                    elementType: "all",
                    stylers: [{
                        hue: "#e9ebed"
                    }, {
                        saturation: -78
                    }, {
                        lightness: 67
                    }, {
                        visibility: "simplified"
                    }]
                }, {
                    featureType: "landscape",
                    elementType: "all",
                    stylers: [{
                        hue: "#ffffff"
                    }, {
                        saturation: -100
                    }, {
                        lightness: 100
                    }, {
                        visibility: "simplified"
                    }]
                }, {
                    featureType: "road",
                    elementType: "geometry",
                    stylers: [{
                        hue: "#bbc0c4"
                    }, {
                        saturation: -93
                    }, {
                        lightness: 31
                    }, {
                        visibility: "simplified"
                    }]
                }, {
                    featureType: "poi",
                    elementType: "all",
                    stylers: [{
                        hue: "#ffffff"
                    }, {
                        saturation: -100
                    }, {
                        lightness: 100
                    }, {
                        visibility: "off"
                    }]
                }, {
                    featureType: "road.local",
                    elementType: "geometry",
                    stylers: [{
                        hue: "#e9ebed"
                    }, {
                        saturation: -90
                    }, {
                        lightness: -8
                    }, {
                        visibility: "simplified"
                    }]
                }, {
                    featureType: "transit",
                    elementType: "all",
                    stylers: [{
                        hue: "#e9ebed"
                    }, {
                        saturation: 10
                    }, {
                        lightness: 69
                    }, {
                        visibility: "on"
                    }]
                }, {
                    featureType: "administrative.locality",
                    elementType: "all",
                    stylers: [{
                        hue: "#2c2e33"
                    }, {
                        saturation: 7
                    }, {
                        lightness: 19
                    }, {
                        visibility: "on"
                    }]
                }, {
                    featureType: "road",
                    elementType: "labels",
                    stylers: [{
                        hue: "#bbc0c4"
                    }, {
                        saturation: -93
                    }, {
                        lightness: 31
                    }, {
                        visibility: "on"
                    }]
                }, {
                    featureType: "road.arterial",
                    elementType: "labels",
                    stylers: [{
                        hue: "#bbc0c4"
                    }, {
                        saturation: -93
                    }, {
                        lightness: -2
                    }, {
                        visibility: "simplified"
                    }]
                }],
                y = [{
                    featureType: "landscape.natural",
                    elementType: "geometry.fill",
                    stylers: [{
                        visibility: "on"
                    }, {
                        color: "#e0efef"
                    }]
                }, {
                    featureType: "poi",
                    elementType: "geometry.fill",
                    stylers: [{
                        visibility: "on"
                    }, {
                        hue: "#1900ff"
                    }, {
                        color: "#c0e8e8"
                    }]
                }, {
                    featureType: "landscape.man_made",
                    elementType: "geometry.fill"
                }, {
                    featureType: "road",
                    elementType: "geometry",
                    stylers: [{
                        lightness: 100
                    }, {
                        visibility: "simplified"
                    }]
                }, {
                    featureType: "road",
                    elementType: "labels",
                    stylers: [{
                        visibility: "off"
                    }]
                }, {
                    featureType: "water",
                    stylers: [{
                        color: "#7dcdcd"
                    }]
                }, {
                    featureType: "transit.line",
                    elementType: "geometry",
                    stylers: [{
                        visibility: "on"
                    }, {
                        lightness: 700
                    }]
                }],
                h = [{
                    featureType: "landscape",
                    stylers: [{
                        hue: "#F1FF00"
                    }, {
                        saturation: -27.4
                    }, {
                        lightness: 9.4
                    }, {
                        gamma: 1
                    }]
                }, {
                    featureType: "road.highway",
                    stylers: [{
                        hue: "#0099FF"
                    }, {
                        saturation: -20
                    }, {
                        lightness: 36.4
                    }, {
                        gamma: 1
                    }]
                }, {
                    featureType: "road.arterial",
                    stylers: [{
                        hue: "#00FF4F"
                    }, {
                        saturation: 0
                    }, {
                        lightness: 0
                    }, {
                        gamma: 1
                    }]
                }, {
                    featureType: "road.local",
                    stylers: [{
                        hue: "#FFB300"
                    }, {
                        saturation: -38
                    }, {
                        lightness: 11.2
                    }, {
                        gamma: 1
                    }]
                }, {
                    featureType: "water",
                    stylers: [{
                        hue: "#00B6FF"
                    }, {
                        saturation: 4.2
                    }, {
                        lightness: -63.4
                    }, {
                        gamma: 1
                    }]
                }, {
                    featureType: "poi",
                    stylers: [{
                        hue: "#9FFF00"
                    }, {
                        saturation: 0
                    }, {
                        lightness: 0
                    }, {
                        gamma: 1
                    }]
                }],
                v = [{
                    featureType: "administrative",
                    stylers: [{
                        visibility: "off"
                    }]
                }, {
                    featureType: "poi",
                    stylers: [{
                        visibility: "simplified"
                    }]
                }, {
                    featureType: "road",
                    elementType: "labels",
                    stylers: [{
                        visibility: "simplified"
                    }]
                }, {
                    featureType: "water",
                    stylers: [{
                        visibility: "simplified"
                    }]
                }, {
                    featureType: "transit",
                    stylers: [{
                        visibility: "simplified"
                    }]
                }, {
                    featureType: "landscape",
                    stylers: [{
                        visibility: "simplified"
                    }]
                }, {
                    featureType: "road.highway",
                    stylers: [{
                        visibility: "off"
                    }]
                }, {
                    featureType: "road.local",
                    stylers: [{
                        visibility: "on"
                    }]
                }, {
                    featureType: "road.highway",
                    elementType: "geometry",
                    stylers: [{
                        visibility: "on"
                    }]
                }, {
                    featureType: "water",
                    stylers: [{
                        color: "#84afa3"
                    }, {
                        lightness: 52
                    }]
                }, {
                    stylers: [{
                        saturation: -17
                    }, {
                        gamma: .36
                    }]
                }, {
                    featureType: "transit.line",
                    elementType: "geometry",
                    stylers: [{
                        color: "#3f518c"
                    }]
                }],
                b = [{
                    featureType: "all",
                    elementType: "all",
                    stylers: [{
                        invert_lightness: !0
                    }, {
                        saturation: 10
                    }, {
                        lightness: 30
                    }, {
                        gamma: .5
                    }, {
                        hue: "#435158"
                    }]
                }],
                T = [{
                    stylers: [{
                        hue: "#ff8800"
                    }, {
                        gamma: .4
                    }]
                }];
            switch (a.data("snazzy-map-theme")) {
            case "grayscale":
                t = m;
                break;
            case "blue":
                t = c;
                break;
            case "dark":
                t = f;
                break;
            case "pink":
                t = g;
                break;
            case "light":
                t = u;
                break;
            case "blue-essence":
                t = y;
                break;
            case "bentley":
                t = h;
                break;
            case "retro":
                t = v;
                break;
            case "cobalt":
                t = b;
                break;
            case "brownie":
                t = T;
                break;
            default:
                t = m
            }
            var w = "custom_style",
                k = t,
                C = new google.maps.LatLng(s, l),
                x = {
                    zoom: i,
                    center: C,
                    mapTypeControlOptions: {
                        mapTypeIds: [google.maps.MapTypeId.ROADMAP, w]
                    },
                    mapTypeControl: !1,
                    mapTypeId: w,
                    scrollwheel: !1,
                    draggable: !0
                },
                F = new google.maps.Map(document.getElementById("map"), x),
                I = {
                    name: "Custom Style"
                },
                S = new google.maps.StyledMapType(k, I);
            F.mapTypes.set(w, S), google.maps.event.addDomListener(window, "resize", function () {
                var e = F.getCenter();
                google.maps.event.trigger(F, "resize"), F.setCenter(e)
            });
            var z = '<div id="content"><div id="siteNotice"></div><h3 id="firstHeading" class="firstHeading">' + p + '</h3><div id="bodyContent"><p>' + d + "</p></div></div>",
                D = new google.maps.InfoWindow({
                    content: z
                }),
                q = new google.maps.MarkerImage(n, new google.maps.Size(r, o), new google.maps.Point(0, 0)),
                P = new google.maps.LatLng(s, l),
                j = new google.maps.Marker({
                    position: P,
                    map: F,
                    icon: q,
                    title: p,
                    zIndex: 3
                });
            google.maps.event.addListener(j, "click", function () {
                D.open(F, j)
            })
        }
    }
    e(document).ready(function () {
	
		
        var s = new RegExp("MSIE 8.0"),
            l = s.test(navigator.userAgent);
        l && e(".menu-nav").find("li").last().addClass("menu-item-last"), e(".toggle-button").on("click", function (t) {
            t.preventDefault(), e(".filters > ul").toggleClass("show-filters")
        }), e(".slider").length && e(".slider").owlCarousel({
            navigation: !0,
            pagination: !1,
            singleItem: !0,
            navigationText: ['<i class="fa fa-caret-left"></i>', '<i class="fa fa-caret-right "></i>']
        }), e(".blog-slide").length && e(".blog-slide").owlCarousel({
            navigation: !0,
            pagination: !1,
            singleItem: !0,
            navigationText: ['<i class="fa fa-caret-left"></i>', '<i class="fa fa-caret-right "></i>']
        }), e(".portfolio-slide").length && e(".portfolio-slide").owlCarousel({
            navigation: !0,
            pagination: !1,
            singleItem: !0,
            navigationText: ['<i class="fa fa-caret-left"></i>', '<i class="fa fa-caret-right "></i>']
        }), e(".slider2").length && e(".slider2").owlCarousel({
            items: 3,
            itemsDesktop: [1199, 3],
            itemsDesktopSmall: [992, 2],
            itemsTablet: [767, 2],
            itemsTabletSmall: [600, 1],
            navigation: !0,
            pagination: !1,
            navigationText: ['<i class="fa fa-caret-left"></i>', '<i class="fa fa-caret-right "></i>']
        }), e(".slider3").length && e(".slider3").owlCarousel({
            navigation: !0,
            pagination: !1,
            singleItem: !0,
            navigationText: ['<i class="fa fa-caret-left"></i>', '<i class="fa fa-caret-right "></i>']
        }), e(".slider4").length && e(".slider4").owlCarousel({
            items: 5,
            itemsDesktop: [1199, 3],
            itemsDesktopSmall: [992, 2],
            itemsTablet: [767, 2],
            itemsTabletSmall: [600, 1],
            autoPlay: 3e3,
            slideSpeed: 200,
            navigation: !1,
            pagination: !1,
            navigationText: ['<i class="fa fa-caret-left"></i>', '<i class="fa fa-caret-right "></i>']
        });
        var n = e(".menu-nav").clone().appendTo("Body");
        n.addClass("menu-responsive"), n.wrap("<div id='menu-wrap' class='menu-responsive-container'></div>"), e(".menu-dropdown").children("a").append('<i class="fa fa-caret-down"></i>'), e("#menu-wrap").prepend('<a class="close-menu" href="javascript:"><i class="fa fa-chevron-right"></i></a>'), e("#menu-wrap").find(".dropdown").prepend('<li class="menu-item back-item"><a class="back-item-text" href="javascript:">Back&nbsp;&nbsp;<i class="fa fa-hand-o-right"></i></a></li>'), e("#menu-wrap").find(".menu-dropdown").prepend('<span class="menu-toggle-dropdown"><i class="fa fa-angle-right"></i></span>'), e(".menu-responsive-toggle").on("click", function (t) {
            t.stopPropagation(), setTimeout(function () {
                n.parent().addClass("menu-show"), e("body").addClass("menu-slide")
            }, 300), e(".wrapper").addClass("page-translate"), e(".header-sticky").addClass("header-translate"), e(".dropdown-active").length && e(".dropdown").removeClass("dropdown-active")
        }), e(document).on("click touchstart", function (t) {
            e(t.target).closest("#menu-wrap, .back-item, .back-item-text, .dropdown-active").length || (e(".menu-responsive-container").removeClass("menu-show"), setTimeout(function () {
                e("body").removeClass("menu-slide")
            }, 300), e(".wrapper").removeClass("page-translate"), e(".header-sticky").removeClass("header-translate"), e(".dropdown-active").length && e(".dropdown").removeClass("dropdown-active"))
        }), e(".menu-responsive-container").find("a.close-menu").on("click", function () {
            e(".menu-responsive-container").removeClass("menu-show"), setTimeout(function () {
                e("body").removeClass("menu-slide")
            }, 300), e(".wrapper").removeClass("page-translate"), e(".header-sticky").removeClass("header-translate")
        }), e(".menu-toggle-dropdown").on("click", function () {
            e(this).parent().children(".dropdown").toggleClass("dropdown-active"), e(".menu-responsive").toggleClass("menu-state")
        }), e(".back-item-text").on("click", function () {
            e(".menu-responsive").toggleClass("menu-state"), e(this).parent().parent().toggleClass("dropdown-active")
        });
        var r = e(".header-sticky").outerHeight();
        e(window).scroll(function () {
            var t = e(window).scrollTop();
            console.log(e("body").children(".header-sticky")), t > r ? (e(".header-sticky").addClass("fixed"), e(".header-sticky").closest("body").find(".wrapper").css("margin-top", r), 0 == e("body").children(".header-sticky").length && e(".header-sticky").prependTo("body")) : (e(".header-sticky").removeClass("fixed"), e(".header-sticky").closest("body").find(".wrapper").css("margin-top", "0"), 0 == e(".wrapper").children(".header-sticky").length && e(".header-sticky").prependTo(".wrapper")), console.log(t)
        }), e(".contact-form").length > 0 && e(".contact-form").validate({
            rules: {
                name: {
                    required: !0,
                    minlength: 2
                },
                email: {
                    required: !0,
                    email: !0
                },
                message: {
                    required: !0,
                    minlength: 10
                }
            },
            messages: {
                name: {
                    required: "Please enter your first name.",
                    minlength: e.format("At least {0} characters required.")
                },
                email: {
                    required: "Please enter your email.",
                    email: "Please enter a valid email."
                },
                message: {
                    required: "Please enter a message.",
                    minlength: e.format("At least {0} characters required.")
                }
            },
            submitHandler: function (t) {
                return e(".submit-contact").html("Sending..."), e(t).ajaxSubmit({
                    success: function (t) {
                        e("#contact-content").slideUp(600, function () {
                            e("#contact-content").html(t).slideDown(600)
                        })
                    }
                }), !1
            }
        }), t(), i(), e(window).on("load", function () {
            e("body").addClass("loaded"), a(".text-box"), e(window).resize(function () {
                a(".text-box")
            }), e(".js-masonry").length && e(".js-masonry").masonry({
                columnWidth: ".grid-sizer",
                itemSelector: ".js-item"
            })
        })
    })
}(jQuery); // JavaScript Document