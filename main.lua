-----------------------------------------------------------------------------------------
-- 本範例用來示範Widget中的TableView使用做法，包含一般TableView和分類型TableView
-- main.lua
-- Author: Zack Lin
-- Time: 2016/8/12
-----------------------------------------------------------------------------------------
--=======================================================================================
--引入各種函式庫
--=======================================================================================
display.setStatusBar( display.HiddenStatusBar )
local widget = require( "widget" )
--=======================================================================================
--宣告各種變數
--=======================================================================================
_SCREEN = {
	WIDTH = display.viewableContentWidth,
	HEIGHT = display.viewableContentHeight
}
_SCREEN.CENTER = {
	X = display.contentCenterX,
	Y = display.contentCenterY
}

local init
local createBasicTable
local createCategoryTable
local onRowRender
local onRowTouch
local scrollListener
--=======================================================================================
--宣告與定義main()函式
--=======================================================================================
local main = function (  )
	init()
end

--=======================================================================================
--定義其他函式
--=======================================================================================
-- 生成最基本的TableView
createBasicTable = function (  )
	local tableView = widget.newTableView(
	    {
	        left = 0,
	        top = 0,
	        height = 330,
	        width = 300,
	        isBounceEnabled = true,
	        --isLocked = true,
	        noLines = true,
	        --backgroundColor = {1,0,0},
	        hideBackground = true,
	        onRowRender = onRowRender,
	        onRowTouch = onRowTouch,
	        --listener = scrollListener
	    }
	)
	-- 加入 40 rows
	for i = 1, 40 do
	    -- Insert a row into the tableView
	    tableView:insertRow{}
	end
	-- tableView:scrollToIndex(15)
	--tableView.height = 100

end

-- 生成含分類的TableView
createCategoryTable = function (  )
	local tableView = widget.newTableView(
	    {
	        left = 0,
	        top = 0,
	        height = 330,
	        width = 300,
	        onRowRender = onRowRender,
	        onRowTouch = onRowTouch,
	        listener = scrollListener
	    }
	)

	-- 加入 40 rows
	for i = 1, 40 do

	    local isCategory = false  --是否為分類Row的屬性
	    local rowHeight = 36
	    local rowColor = { default={1,1,1}, over={1,0.5,0,0.2} }
	    local lineColor = { 0.5, 0.5, 0.5 }

	    --如果是第1和21列，則為分類
	    if ( i == 1 or i == 21 ) then
	        isCategory = true
	        rowHeight = 40
	        rowColor = { default={0.8,0.8,0.8,1} }
	        lineColor = { 1, 0, 0 }
	    end

	    -- Insert a row into the tableView
	    tableView:insertRow(
	        {
	            isCategory = isCategory,
	            rowHeight = rowHeight,
	            rowColor = rowColor,
	            lineColor = lineColor
	        }
	    )
	end
end

init = function (  )
	--createBasicTable()
	createCategoryTable()

end

--負責渲染Row
onRowRender = function ( event )
	 -- 取得Row Group的參考
    local row = event.row

    -- 先暫存Row的寬高，以避免在加入子元件後被變更得不到舊的值
    --local rowHeight , rowWidth = row.contentHeight , row.contentWidth

    --建立Row的內容
    local rowTitle = display.newText( row, "Row " .. row.index, 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )
    rowTitle.anchorX = 0
    rowTitle.x = 0
    --rowTitle.y = rowHeight * 0.5
    rowTitle.y = row.contentHeight * 0.5
end

--負責處理Row的Touch事件
onRowTouch = function ( event )
	print("Event Phase:" , event.phase)  --輕點為tap，重點分為press和release，往左滑為swipeLeft，往右滑為swipeRight
	print("Event Target:" , event.target) --Source參考，為觸發事件的row
	print("Event Row Index:" , event.target.index) --觸發事件row的索引值
end

scrollListener = function ( event )
	print("Event Phase:" , event.phase) --按下去為began，當上下滑動TableView為moved，當放開為ended
	print("Event Direction:" , event.direction) --碰到上方頂點為down，下方底部為up，其他時間為nil
	print("Event LimitReached" , event.limitReached) --當碰到極限時為true，其他時間為nil
end

--=======================================================================================
--呼叫主函式
--=======================================================================================
main()