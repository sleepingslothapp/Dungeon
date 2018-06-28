return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.0.3",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 7,
  height = 7,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "testmap",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "testmap.png",
      imagewidth = 128,
      imageheight = 128,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      terrains = {},
      tilecount = 64,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "floor",
      x = 0,
      y = 0,
      width = 7,
      height = 7,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        20, 20, 20, 12, 20, 20, 20,
        20, 12, 12, 12, 12, 12, 20,
        20, 12, 12, 12, 12, 12, 20,
        12, 12, 12, 12, 12, 12, 20,
        20, 12, 12, 12, 12, 12, 20,
        20, 12, 12, 12, 12, 12, 20,
        20, 20, 20, 12, 20, 20, 20
      }
    },
    {
      type = "tilelayer",
      name = "backwall",
      x = 0,
      y = 0,
      width = 7,
      height = 7,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 2, 2, 0, 2, 2, 0,
        2, 10, 10, 0, 10, 10, 0,
        10, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0,
        10, 2, 2, 0, 2, 2, 0,
        0, 10, 10, 0, 10, 10, 0,
        0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "frontwall",
      x = 0,
      y = 0,
      width = 7,
      height = 7,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 4, 0, 6, 0, 0,
        0, 6, 0, 0, 0, 4, 0,
        0, 0, 0, 0, 0, 4, 0,
        0, 0, 0, 0, 0, 4, 0,
        0, 6, 0, 0, 0, 4, 0,
        0, 0, 4, 0, 6, 0, 0,
        0, 0, 4, 0, 6, 0, 0
      }
    }
  }
}
