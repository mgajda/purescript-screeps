"use strict";

exports.getRoomVisual = function (room) {
    return function () { return room.visual; }
}
