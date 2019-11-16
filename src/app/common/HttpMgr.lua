

local HttpMgr = class("HttpMgr")


function HttpMgr:ctor() 
    self._handler = nil 
end


function HttpMgr:getInstance()
	if not self._instance then
		self._instance = HttpMgr.new()
	end
	return self._instance
	
end


-- GET
function HttpMgr:request( url,successCall,failedCall )
	local xhr = cc.XMLHttpRequest:new()
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON -- 相应类型为字符串
	xhr:setRequestHeader( "Content-Type" , "application/json")
	xhr:open("GET", url)

	local function onReadyStateChange() 
	    if xhr.readyState == 4 then
	        print( xhr.response )

	        local str = xhr.response
	        local cc = json.decode( str )

	        if successCall then
	        	successCall()
	        end
	    else
	       	print( "请求数据失败" )
	       	if failedCall then
	       		failedCall()
	       	end
	    end
	end
	-- 注册脚本方法回调  
	xhr:registerScriptHandler(onReadyStateChange)
	xhr:send()
end


rawset(_G, "HttpMgr", HttpMgr)