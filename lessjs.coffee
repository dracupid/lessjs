###
    A javascript utilities which you may never use.
    @author Draucpid
    @date Dec. 11st, 2014
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

    typeOf = (val)->
        typeStr = Object::toString.call val
        typeStr.match(/\[object (.*?)\]/)[1]

    ###
    UTF-16 has two kinds of lengths
    1. U+0000 ~ U+FFFF: length is 16 bits (2 bytes)
    2. U+10000 ~ U+10FFFF: length is 32 bits (4 bytes), 
        of which the first two bytes are 0xD800 ~ 0xDBFF, the last two are 0xDC00 ~ 0xDFFF
    When it comes to the second situation, the browser will recognize the four bytes as a character and display correctly, 
    but its length will be regarded as 2 units.
    ###
    strToArray = (str, utf8Only = true)->
        if utf8Only then return str.split('')
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

    splitChar = (str, spliter = ' ')->
        Array.prototype.join.call(str, spliter)

    # Native btoa and atob cannot deal with unicode characters
    btoaUnicode = (str)->
        btoa unescape encodeURIComponent str

    atobUnicode = (str)->
        decodeURIComponent escape atob str


    max = (arr)->
        arr.reduce (max, item)->
            if item > max then item else max

    inArray = (arr, item)->
        arr.indexOf(item) >= 0

    isLittleEndian = do ->
        buffer = new ArrayBuffer 2
        new DataView(buffer).setInt16 0, 256, true

        new Int16Array(buffer)[0] is 256;


    # repeat a string n times
    String::repeat = (times)->
        Array(times).join @

    # title string
    String::title = ()->
        @.trim().split(/\s+/).map (word)->
            word[0].toUpperCase() + word[1..]
        .join ' '

    # remove duplicate items
    Array::unique = ->
        obj = {}
        obj[@[key]] = @[key] for key in [0..@length]
        value for key, value of obj

    # revert a obj array to dict can be searched by some property
    Array::toDict = (keyProperty) ->
        @reduce (dict, obj)->
            dict[obj[keyProperty]] = obj if obj[key]?
            dict
        , {}
    Array::shuffle = ->
        @sort -> 0.5 - Math.random()

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

    class Model
        constructor: (@_attr)->
        get: (key)->
            @_attr[key]
        set: (key, value)->
            @_attr[key] = value
            @
        on: (e, handler)->




