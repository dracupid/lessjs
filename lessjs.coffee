###
    A javascript utilities which you may never use.
    @author: Draucpid
    @date: Dec. 11st, 2014
###
((root, factory)->
    if typeof module is "object" && typeof module.exports is "object"
        module.exports = factory root
    else if typeof define is 'function' and define.amd
        define 'lessjs', [], -> factory root
    else
        root.L = factory root
) this, (root)->

    # If a value is exactly `NaN`
    # Param: {Any}
    # Return: {Boolean}
    isNaN = (val)->
        val isnt val

    # easist and fastest floor function
    floor = (num)->
        ~~num
    # convert a rgb color to hex
    rgb2Hex = (r, g, b)->
        '#' + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).substr(1)


    ###
    UTF-16 has two kinds of lengths
    1. U+0000 ~ U+FFFF: length is 16 bits (2 bytes)
    2. U+10000 ~ U+10FFFF: length is 32 bits (4 bytes), 
        of which the first two bytes are 0xD800 ~ 0xDBFF, the last two are 0xDC00 ~ 0xDFFF
    When it comes to the second situation, the browser will recognize the four bytes as a character and display correctly, 
    but its length will be regarded as 2 units.
    ###
    strToArray = (str)->
        length = str.length
        index = -1
        array = []

        while(++index < length)
            char = str.charAt index
            charCode = char.charCodeAt 0

            if 0xD800 <= charCode <= 0xDBFF
                array.push char + str.charAt ++index
            else
                array.push char
        array

    # Native btoa and atob cannot deal with unicode characters
    btoaUnicode = (str)->
        btoa unescape encodeURIComponent str

    atobUnicode = (str)->
        decodeURIComponent escape atob str

    # Array-Like objects, such as arguments Object, HTMLCollection
    class ArrayLike
        constructor: (@length = 0)->
            for i in [0...length]
                @[i] = null
        toArray: (self = @)->
            Array.prototype.slice.call self
        forEach: (self, func)->
            if arguments.length is 1 then 
                Array.prototype.forEach.call @, self
            else
                Array.prototype.forEach.call self, func

    ArrayLike.toArray = Array::toArray
    ArrayLike.forEach = Array::forEacgh

    # Convert many paramters or one array paramter to an array.
    argsToArray = ->
        Array::concat.apply [], arguments.callee.caller.arguments

    # Bit flag
    class Flag
        constructor: ()->
            @flagNum = 0
            @flagState = 0

        add: (flagArr)->
            flagArr.forEach (flag)->
                @flagMap[flag] = 1 << @flagNum++

        mask: (flagArr)->
            flagArr.map (flagName)->
                @flagMap[flagName]
            .reduce (total, cur)->
                total | cur

        turnOnAll: ()->
            @flagState = if @flagNum then -1 >>> (32 - @flagNum) else 0
        turnOn: (flagArr)->
            @flagState |= @mask flagArr
        turnOffAll: ()->
            @flagState = 0
        turnOff: (flagArr)->
            @flagState &= ~(@mask flagArr)

        setAs: (flagArr)->
            @flagState &= @mask flagArr
        toggleAll: ()->
            @flagState = ~flags
        toggle: (flagArr)->
            @flagState ^= @mask flagArr

        checkOn: (curState, flag)->
            curState & @flagMap[flag]
        checkOff: (curState, flag)->
            not @checkOn curState, flag


