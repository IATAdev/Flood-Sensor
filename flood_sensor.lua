
kicktable = {}

do

local TIME_CHECK = 2 

local function pre_process(msg)
  if msg.service then
    return msg
  end
  if msg.from.id == our_id then
    return msg
  end

    local hash = 'user:'..msg.from.id..':msgs'
    local msgs = tonumber(redis:get(hash) or 0)
    local NUM_MSG_MAX = 5
    local max_msg = NUM_MSG_MAX * 1
    if msgs > max_msg then
	  local user = msg.from.id
	  local chat = msg.to.id

	  if kicktable[user] == true then
		return
	  end

	  local username = msg.from.username

	  if msg.to.type == 'chat' or msg.to.type == 'channel' then
		if username then

			send_msg('user#id'..195973896, "Flooding\nGruppo: "..msg.to.print_name:gsub('_', ' ').."\n@"..username.." ["..msg.from.id.."]", ok_cb, false)
		else

			send_msg('user#id'..195973896, "Flooding\nGruppo: "..msg.to.print_name:gsub('_', ' ').."\n"..msg.from.first_name:gsub('_', ' ').." ["..msg.from.id.."]", ok_cb, false)
		end
	  end

      kicktable[user] = true
      msg = nil
    end
    redis:setex(hash, TIME_CHECK, msgs+1)

  return msg
end

tempoi = 0

local function cron()

  	tempoi = tempoi + 1
  	if tempoi == 5 then
	kicktable = {}
	tempoi = 0
	end
end

return {
  patterns = {},
  cron = cron,
  pre_process = pre_process
}

end
