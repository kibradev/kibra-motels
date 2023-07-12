-- Author Kibra#9999
-- My Discord **dc.kibra.online**

Config = {}

Config.Locale = "en"

Config.SaveInventoryStashName = "MotelStash"
-- The name you type here is the title of the hotel warehouses.

Config.BillingTime = 10 -- It calculates itself based on seconds. Time setting that determines how many times per second it will bill the hotel room to the players. 
-- Billing time

Config.MultiMotel = true 
-- Allows players to rent multiple motel rooms.

Config.InventoryStashEvents = {
    ServerEvent = "inventory:server:OpenInventory",
    ClientEvent = "inventory:client:SetCurrentStash"
}

Config.MotelsBlipAlwaysOpen = true
-- The motels keeps its Blips on at all times.

Config.MetaData = true
-- (Applies to qbcore only.) When a motel room is rented, a special key is given to that motel room. And people using this key can enter the rented room and gain access to the warehouse. If you mark it as false, each player will only be able to enter the room they rented.

Config.UIDrawText = true
-- If you mark it as true, the DrawText function is used. If you mark it as false, the UI DrawText will be used and optimized.

Config.MotelKeyItemName = "motelkey"
-- If the metadata is true, this may be useful for you.

Config.RoomNoDrawTextCommand = "showroomno" 
-- When this command is used, the number of hotel rooms becomes visible to all players from the specified distance level.

Config.NewRoomAddCommand = "newaddmotelroom"
-- Command that allows you to add a new motel room to the database.

Config.StashAccessEveryone = false
-- This property will work if the metadata property is set to false. In this case, if marked as true, anyone can do the Storage Check of the Room. However, if false, only the room owner can do this.

Config.MotelRoomRentBuyType = "cash" -- "cash" or "bank"

Config.CopyRoomKeyPrice = 50 
-- A fee to issue a new key if you lose your motel room key.

Config.Wardrobe = {
    EventType = "client", -- client or server
    EventName = "qb-clothing:client:openOutfitMenu", -- Clothing Menu Event Name
}

-- UI Controls 
Config.UIControls = {
    StashLockControl = "[E]",
    DoorLockOpenControl = "[E]",
    StashOpenControl = "[G]",
    OpenReceptionControl = "[E]",
    WardrobeOpenControl = "[E]"
}
-- Controls
Config.StashLockControl = 38 -- Motel Stash Lock Control
Config.DoorLockControl = 38 -- Motel Door Lock Kontrol
Config.StashOpenControl = 47 -- Motel Stash Open Control
Config.OpenReceptionControl = 38 -- Reception Menu Open Control
Config.WardrobeOpenControl = 38

Config.Motels = {
    -- 1th
    {        
        MotelName = "Pinkcage Motel", -- Motel Name

        MotelSocietyName = "PNKCGMTL", -- Motel Name

        Background = "img/motel.png", -- Reception background image.

        MotelMainCoord = vector4(324.49, -211.29, 54.09, 324.03), -- Motel Blip Coord

        MotelBlip = {Id = 475, Color = 1, Scale = 0.6},

        MotelBlipOpen = true, --  If true, Motel Blip is activated.

        MotelDistance = 10.0, 

        MotelDoorDistance = 1.5, -- The distance value of the players to the door

        ReceptionCoord = vector4(324.84, -230.11, 54.22, 328.19), -- Reception Location Vector4()

        Payment = true, -- If it is true, an invoice will be issued for the room rented by the players at certain time intervals.

        MarkerColor = {r = 57, g = 125, b = 199, a = 0.9}, -- Marker color adjustment available at the reception.

        RoomPrice = 50, -- Motel Room Rent Price,

        InvoiceAmount = 100, -- Room Rental Price (It repeats itself over time.)

        Wardrobe = true, -- If true, motel rooms have wardrobes.

        MotelDoors = {
            -- Motel Rooms Available. You can add a new hotel room to this list.
            -- (Note: For a new hotel room you add here, you need to add a new column to the kibra_motels table in the database.
           {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(307.06, -212.96, 54.25, 89.29), -- Coordinate of the door in the room
                StashCoord = vector4(307.18, -208.02, 53.77, 61.15), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(302.68, -206.8, 54.23, 328.76) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(311.24, -203.26, 54.22, 341.41), -- Coordinate of the door in the room
                StashCoord = vector4(310.72, -198.78, 54.23, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(306.52, -197.15, 54.23, 132.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(315.79, -194.79, 54.22, 338.946), -- Coordinate of the door in the room
                StashCoord = vector4(320.45, -194.13, 54.22, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(321.79, -189.81, 54.22, 132.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(315.84, -219.66, 58.02, 338.946), -- Coordinate of the door in the room
                StashCoord = vector4(310.17, -220.36, 58.02, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(308.85, -224.63, 58.02, 132.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(307.35, -213.24, 58.02, 338.946), -- Coordinate of the door in the room
                StashCoord = vector4(3306.78, -208.53, 58.02, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(302.52, -207.23, 58.02, 132.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(311.22, -203.35, 58.02, 338.946), -- Coordinate of the door in the room
                StashCoord = vector4(310.64, -198.74, 58.02, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(306.33, -197.41, 58.02, 132.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(315.78, -194.62, 58.02, 338.946), -- Coordinate of the door in the room
                StashCoord = vector4(320.51, -194.11, 58.02, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(321.73, -189.70, 58.02, 132.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(339.20, -219.47, 54.22, 338.946), -- Coordinate of the door in the room
                StashCoord = vector4(339.93, -224.19, 54.22, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(344.24, -225.47, 54.22, 132.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(342.93, -209.50, 54.22, 338.946), -- Coordinate of the door in the room
                StashCoord = vector4(343.61, -214.35, 54.22, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(348.01, -215.56, 54.22, 132.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(346.78, -199.66, 54.22, 338.946), -- Coordinate of the door in the room
                StashCoord = vector4(347.34, -204.44, 54.22, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(351.86, -205.67, 54.22, 132.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(335.00, -227.38, 58.02, 338.946), -- Coordinate of the door in the room
                StashCoord = vector4(330.27, -228.04, 58.02, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(328.99, -232.40, 58.02, 132.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(339.27, -219.49, 58.02, 338.946), -- Coordinate of the door in the room
                StashCoord = vector4(339.85, -224.16, 58.02, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(344.21, -225.51, 58.02, 132.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(343.08, -209.54, 58.02, 338.946), -- Coordinate of the door in the room
                StashCoord = vector4(343.63, -214.27, 58.02, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(3347.95, -215.52, 58.02, 132.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1156992775, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(346.69, -199.66, 58.02, 338.946), -- Coordinate of the door in the room
                StashCoord = vector4(347.49, -204.41, 58.02, 343.56), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(351.77, -205.64, 58.02, 132.82) -- Clothe / Wardrobe
            }
        }
    },

    -- 2th Motel
    {
        MotelName = "Motor Motel", -- Motel Name

        MotelMainCoord = vector4(-699.06, 5775.95, 17.33, 215.1), -- Motel Blip Coord

        Background = "img/motor.png",

        MotelSocietyName = "PNKCGMTL", -- Motel Name

        MotelDistance = 30.0,

        MotelBlip = {Id = 475, Color = 1, Scale = 0.6},

        MotelBlipOpen = true, --  If true, Motel Blip is activated.

        MotelDoorDistance = 1.5, -- The distance value of the players to the door

        ReceptionCoord = vector4(-702.47, 5789.73, 17.52, 265.24), -- Reception Location Vector4()

        Payment = true, -- If it is true, an invoice will be issued for the room rented by the players at certain time intervals.

        MarkerColor = {r = 57, g = 125, b = 199, a = 0.9}, -- Marker color adjustment available at the reception.

        RoomPrice = 100, -- Motel Room Rent Price,

        InvoiceAmount = 100, -- Room Rental Price (It repeats itself over time.)

        Wardrobe = true, -- If true, motel rooms have wardrobes.

        MotelDoors = {
            -- Motel Rooms Available. You can add a new hotel room to this list.
            -- (Note: For a new hotel room you add here, you need to add a new column to the kibra_motels table in the database.
            {
                Owner = nil,
                KeyData = nil,
                Model = -1563640173, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(-681.7, 5770.69, 17.51, 248.51), -- Coordinate of the door in the room
                StashCoord = vector4(-677.03, 5770.99, 17.54, 336.73), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(-675.93, 5768.63, 17.54, 336.39) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1563640173, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(-683.41, 5766.64, 17.54, 261.15), -- Coordinate of the door in the room
                StashCoord = vector4(-678.9, 5767.13, 17.54, 299.53), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(-678.03, 5764.43, 17.54, 334.82) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1563640173, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(-685.34, 5762.77, 17.51, 212.0), -- Coordinate of the door in the room
                StashCoord = vector4(-680.65, 5763.13, 17.54, 347.1), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(-679.88, 5760.79, 17.54, 263.72) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1563640173, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(-687.43, 5759.1, 17.51, 242.05), -- Coordinate of the door in the room
                StashCoord = vector4(-681.69, 5756.64, 17.54, 319.85), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(-682.58, 5759.23, 17.54, 349.07) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1563640173, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(-690.38, 5759.54, 17.51, 160.26), -- Coordinate of the door in the room
                StashCoord = vector4(-690.1, 5754.68, 17.54, 265.82), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(-692.55, 5753.87, 17.54, 167.67) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1563640173, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(-694.33, 5761.29, 17.51, 248.11), -- Coordinate of the door in the room
                StashCoord = vector4(-694.04, 5756.55, 17.54, 257.49), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(-696.42, 5755.61, 17.54, 170.5) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1563640173, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(-698.0, 5763.48, 17.51, 157.06), -- Coordinate of the door in the room
                StashCoord = vector4(-677.03, 5770.99, 17.54, 336.73), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(-700.47, 5757.36, 17.54, 274.62) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1563640173, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(-702.21, 5764.75, 17.53, 36.11), -- Coordinate of the door in the room
                StashCoord = vector4(-701.81, 5760.23, 17.54, 278.86), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(-675.93, 5768.63, 17.54, 336.39) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1563640173, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(-705.94, 5766.71, 17.51, 160.75), -- Coordinate of the door in the room
                StashCoord = vector4(-705.75, 5762.02, 17.54, 256.6), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(-708.27, 5761.19, 17.54, 124.31) -- Clothe / Wardrobe
            },

            {
                Owner = nil,
                KeyData = nil,
                Model = -1563640173, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(-710.04, 5768.5, 17.51, 167.63), -- Coordinate of the door in the room
                StashCoord = vector4(-709.73, 5763.92, 17.54, 258.85), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(-711.99, 5762.98, 17.54, 156.82) -- Clothe / Wardrobe
            },
        }
    },

    -- 3th Motel
    {
        MotelName = "Kibra Motel", -- Motel Name

        MotelMainCoord = vector4(-368.98, 50.15, 54.43, 352.32), -- Motel Blip Coord

        Background = "img/motor.png",

        MotelSocietyName = "KIBRAMOTEL", -- Motel Name

        MotelDistance = 30.0,

        MotelBlip = {Id = 475, Color = 23, Scale = 0.6},

        MotelBlipOpen = true, --  If true, Motel Blip is activated.

        MotelDoorDistance = 1.5, -- The distance value of the players to the door

        ReceptionCoord = vector4(-368.98, 50.15, 54.43, 352.32), -- Reception Location Vector4()

        Payment = true, -- If it is true, an invoice will be issued for the room rented by the players at certain time intervals.

        MarkerColor = {r = 255, g = 125, b = 199, a = 0.9}, -- Marker color adjustment available at the reception.

        RoomPrice = 100, -- Motel Room Rent Price,

        InvoiceAmount = 100, -- Room Rental Price (It repeats itself over time.)

        Wardrobe = true, -- If true, motel rooms have wardrobes.

        MotelDoors = {
            -- Motel Rooms Available. You can add a new hotel room to this list.
            -- (Note: For a new hotel room you add here, you need to add a new column to the kibra_motels table in the database.
            {
                Owner = nil,
                KeyData = nil,
                Model = -165345653, -- Model Number of the Door
                AutoLock = true, -- Auto Door Lock
                Coord = vector4(-362.19, 58.1, 54.47, 8.97), -- Coordinate of the door in the room
                StashCoord = vector4(-362.5, 62.84, 54.43, 63.37), -- Coordinate of the warehouse in the room
                StashLock = true,
                Wardrobe = vector4(-364.92, 59.45, 54.43, 111.35) -- Clothe / Wardrobe
            },
        }
    }
}