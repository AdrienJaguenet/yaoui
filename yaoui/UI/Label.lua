local ui_path = (...):match('(.-)[^%.]+$') .. '.'
local Object = require(ui_path .. 'classic.classic')
local Base = require(ui_path .. 'Base')
local Label = Object:extend('Button')
local Draggable = require(ui_path .. 'Draggable')
local Resizable = require(ui_path .. 'Resizable')
Label:implement(Base)
Label:implement(Draggable)
Label:implement(Resizable)

function Label:new(ui, x, y, w, h, settings)
    local settings = settings or {}
    self.ui = ui
    self.id = self.ui.addToElementsList(self)
    self.type = 'Label'

    self:basePreNew(x, y, w, h, settings)

    self.draggable = settings.draggable or false
    if self.draggable then self:draggableNew(settings) end
    self.resizable = settings.resizable or false
    if self.resizable then self:resizableNew(settings) end

    self:basePostNew()
end

function Label:update(dt, parent)
    if parent then 
        if parent.type == 'Frame' then
            if self.annotation == "Frame's close label" then
                self.ix = parent.w - parent.close_margin_right - parent.close_button_width
                self.iy = parent.close_margin_top
            end
        elseif parent.type == 'Scrollarea' then
            if self.annotation == "Vertical scrollbar's top label" then
                self.ix = parent.area_width + parent.x_offset
                self.iy = 0 + parent.y_offset
            elseif self.annotation == "Vertical scrollbar's bottom label" then
                self.ix = parent.area_width + parent.x_offset
                self.iy = parent.area_height - parent.scroll_button_height + parent.y_offset
            elseif self.annotation == "Horizontal scrollbar's left label" then
                self.ix = 0 + parent.x_offset
                self.iy = parent.area_height + parent.y_offset
            elseif self.annotation == "Horizontal scrollbar's right label" then
                self.ix = parent.area_width - parent.scroll_button_width + parent.x_offset
                self.iy = parent.area_height + parent.y_offset
            elseif self.annotation == "Vertical scrollbar label" then
                self.ix = parent.area_width + parent.x_offset
                self.iy = parent.scroll_button_height + parent.y_offset
            elseif self.annotation == "Horizontal scrollbar label" then
                self.ix = parent.scroll_button_width + parent.x_offset
                self.iy = parent.area_height + parent.y_offset
            end
        end
    end
    self:basePreUpdate(dt, parent)
    if self.resizable then self:resizableUpdate(dt, parent) end
    if self.draggable then self:draggableUpdate(dt, parent) end
    self:basePostUpdate(dt)
end

function Label:draw()
    self:basePreDraw()
    self:basePostDraw()
end

function Label:press()
    self.selected = true
    self.pressed = true
    self.released = true
end

return Label
