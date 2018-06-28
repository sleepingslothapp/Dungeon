local Object = {}

function Object.save(filename,tabledata)
	local jsonData = json.encode(tabledata)
	local path = system.pathForFile( filename, system.DocumentsDirectory)
	local file = io.open(path, "w")
	if file then
		--local contents = tostring( M.score )
		file:write( jsonData)
		io.close( file )
		return true
	else
		print("Error: could not read ", M.filename, ".")
		return false
	end
end

function Object.load(filename)
	local path = system.pathForFile( filename,system.DocumentsDirectory )
	local file = io.open( path, "r" )
	if ( file ~= nil ) then
		local data = file:read( "*a" )
		io.close( file )
		return data
	else
		print("Error: could not read {"..filename.."}.")
		return nil
	end
end

function Object.loadAsset(filename)
	local path = system.pathForFile( filename, system.ResourceDirectory )
	local file = io.open( path, "r" )
	if ( file ~= nil ) then
		local data = file:read( "*a" )
		io.close( file )
		return data
	else
		print("Error: could not read {"..filename.."}.")
		return nil
	end
end

return Object