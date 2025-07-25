<script>

export default {
  data() {
    return {
      password: null,
      appearanceVisible: false,
      descriptionVisible: false,
      viewVisible: false,
      sceneTypeVisible: false,
      error: null,
      sceneType: 'prop',
      scene: {},
      config: {},
      distance: 0.02,
      subtitle: 'test',
      attempts: 0,
      tindex: 0,
      scenetext: '',
      scenedesc: '',
      scenedescType: 'plain',
      scenedescImgurl: '',
      scenedescImgalt: '',
      object: '',
      objectOptions: [
		{
          title: 'Basket - Bread',
          value: 'p_basket06cx'
        },
		{
          title: 'Basket - Flowers',
          value: 'p_basket06bx'
        },
		{
          title: 'Blanket',
          value: 'p_cs_blanket01x'
        },
        {
          title: 'Burning Campfire',
          value: 'mp001_p_mp_campfire03x'
        },
        {
          title: 'Burning Upright Log',
          value: 'mp001_s_splitfirelog02x'
        },
        {
          title: 'Candle - Jarred',
          value: 'p_candle02x'
        },
        {
          title: 'Candle Dripping in Bottle',
          value: 'p_candlebot01x'
        },
        {
          title: 'Candle in Box',
          value: 'p_lanternhang01x'
        },
        {
          title: 'Candle in Stand',
          value: 'p_candlestand'
        },
        {
          title: 'Chest',
          value: 's_lootablebigbluechest03x'
        },
        {
          title: "Flat Menu Clipboard - Dark",
          value: 's_van_menuclipboard01'
        },
        {
          title: "Flat Menu Clipboard - Light",
          value: 's_bla_menuclipboard01'
        },
        {
          title: "Flat Menu Clipboard - Upscale",
          value: 's_sdn_menuclipboard01'
        },
        {
          title: 'Flat Paper',
          value: 'p_cs_letter01b_x'
        },
		{
          title: 'Flowers',
          value: 'p_pot_flowerarng01x'
        },
        {
          title: "Freestanding 'Market' Sandwichboard",
          value: 'p_sandwichboard04x'
        },
        {
          title: "Freestanding 'Now Open' Sandwichboard",
          value: 'p_sandwichboard02x'
        },
        {
          title: 'Hanging Clipboard',
          value: 'p_clipboard02x'
        },
        {
          title: "Hanging Menu Clipboard",
          value: 's_foodmenuclipboard01x'
        },
        {
          title: "Hanging Menu Clipboard - Colorful",
          value: 's_foodmenuclipboard03x'
        },
        {
          title: 'Hanging Paper',
          value: 'p_letter01x'
        },
        {
          title: "Hanging Small 'Open' Sign",
          value: 'p_sign_open_close01x'
        },
        {
          title: "'Help Wanted' Sign",
          value: 'p_helpwantedsign01x'
        },
        {
          title: "Freestanding 'Market' Sandwichboard",
          value: 'p_sandwichboard04x'
        },
        {
          title: 'Lantern - Mini',
          value: 'mp005_p_horselantern01'
        },
        {
          title: 'Lantern - Regular',
          value: 'p_lantern04x'
        },
        {
          title: 'Lantern - Spherical',
          value: 'p_lantern08x'
        },
        {
          title: 'Lantern - Thin Brass',
          value: 'p_lanternbrass02x'
        },
        {
          title: "Open Book",
          value: 'p_journal_open01x'
        },
        {
          title: 'Small Chalkboard',
          value: 'p_chalksign06x'
        },
        {
          title: 'Torch - Short',
          value: 's_interact_torch'
        },
        {
          title: 'Torch - Tall',
          value: 'p_torchpostalwayson01x'
        },

      ],
      expiration: '4',
      expirationOptions: [
        {
          title: '4 Hours',
          value: '4'
        },
        {
          title: '8 Hours',
          value: '8'
        },
        {
          title: '12 Hours',
          value: '12'
        },
        {
          title: '24 Hours',
          value: '24'
        },
        {
          title: '48 Hours',
          value: '48'
        },
        {
          title: '72 Hours',
          value: '72'
        },
      ],
      fontOptions: [
        {
          title: 'Sansexual',
          value: 0
        },
        {
          title: 'Hanky Code',
          value: 1
        },
        {
          title: 'Serif Statement',
          value: 6
        },
        {
          title: 'Riding Voice',
          value: 15
        },
        {
          title: 'Sketchy',
          value: 25
        },
        {
          title: 'Sassy',
          value: 28
        },
      ],
      font: {
        selected: '6',
        tabindex: 0,
        open: false,
      },
      scale: 0.4,
      colorOptions: [
        {
          title: 'White',
          value: 64
        },
        {
          title: 'Bright Red',
          value: 6
        },
        {
          title: 'Bright Green',
          value: 28
        },
        {
          title: 'Bright Yellow',
          value: 21
        },
        {
          title: 'Bright Aqua',
          value: 36
        },
        {
          title: 'Pear',
          value: 22
        },
        {
          title: 'Cornflower Blue',
          value: 40
        },
        {
          title: 'Crimson',
          value: 2
        },
      ],
      color: {
        // options: [
        //   '1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
        //   '11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
        //   '21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
        //   '31', '32', '33', '34', '35', '36', '37', '38', '39', '40',
        //   '41', '42', '43', '44', '45', '46', '47', '48', '49', '50',
        //   '51', '52', '53', '54', '55', '56', '57', '58', '59', '60',
        //   '61', '62', '63', '64'
        // ],
        selected: '64',
        tabindex: 0,
        open: false,
      },
      backgroundColorOptions: [
        {
          title: 'None',
          value: 0
        },
        {
          title: 'Black',
          value: 60
        },
      ],
      backgroundcolor: {
        // options: [
        //   '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
        //   '11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
        //   '21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
        //   '31', '32', '33', '34', '35', '36', '37', '38', '39', '40',
        //   '41', '42', '43', '44', '45', '46', '47', '48', '49', '50',
        //   '51', '52', '53', '54', '55', '56', '57', '58', '59', '60',
        //   '61', '62', '63', '64'
        // ],
        selected: '0',
        tabindex: 0,
        open: false,
      },
      rulesSceneTypeText: [
        v => (!!v) || 'Scene text is required',
        v => (v && v.length >= 12) || 'Scene text must be 12+ characters',
        v => (v && v.length <= 50) || 'Scene text must be less than 50 characters',
      ],
      rulesSceneTypeProp: [
        v => (!!v && v != '') || 'Scene object is required',
      ],
      rulesSceneDescriptionImgUrl: [
        v => (!!v && v != '') || 'Image URL is required',
        v => (/\.(jpg|png|webp)$/.test(v)) || 'Image URL must be a hotlink ending with .png, .jpg, .webp',
      ],
      rulesSceneDescriptionImgAlt: [
        v => (!!v && v != '') || 'Image alt text is required',
      ],
    }
  },
  mounted() {
    let self = this;
    window.addEventListener('message', this.onMessage);
    window.addEventListener('keyup', function (e) {
      if (e.key == "Escape") {
        self.fireEvent('closeAll')
      }
    });
  },
  destroyed() {
    window.removeEventListener('message')
    window.removeEventListener('keyup')
  },
  methods: {
    onMessage(event) {
      if (event.data.type === 'appearance') {
        this.appearanceVisible = event.data.visible
        this.config = event.data.config
        this.subtitle = event.data.subtitle
        this.scene = event.data.scene

        this.scale = event?.data?.scene?.scale
        this.font.options = event?.data?.config?.Fonts
        this.font.selected = event?.data?.scene?.font
        this.color.selected = event?.data?.scene?.color
        this.backgroundcolor.selected = event?.data?.scene?.bg

        this.sceneType = event?.data?.scene?.scene_type

        this.tindex = event?.data?.index
      }

      if (event.data.type === 'description') {
        this.descriptionVisible = event.data.visible
        this.config = event.data.config
        this.subtitle = event.data.subtitle
        this.scene = event.data.scene

        this.scenedesc = event?.data?.scene?.desc
        this.scenedescType = event?.data?.descType
        if (this.scenedescType === 'img') {
          this.scenedescImgurl = event?.data?.descImgurl
          this.scenedescImgalt = event?.data?.descImgalt
          this.scenedesc = ''
        }

        this.tindex = event?.data?.index
      }

      if (event.data.type === 'view') {
        this.viewVisible = event.data.viewVisible
        this.scene = event.data.scene

        this.scenetext = event?.data?.scene?.text
        this.scenedesc = event?.data?.scene?.desc
        this.scenedescType = event?.data?.descType
        if (this.scenedescType === 'img') {
          this.scenedescImgurl = event?.data?.descImgurl
          this.scenedescImgalt = event?.data?.descImgalt
          this.scenedesc = ''
        }
      }

      if (event.data.type === 'sceneType') {
        this.sceneType = event?.data?.sceneType
        this.sceneTypeVisible = event.data.sceneTypeVisible
      }


    },
    fireEvent(eve, opts = {}) {
      fetch(`https://${GetParentResourceName()}/` + eve, {
        method: 'POST',
        body: JSON.stringify(opts)
      })
    },
    async submitFormSceneType() {

      const validFormSceneTypeText = await this.$refs.formSceneTypeText.validate()
      const validFormSceneTypeProp = await this.$refs.formSceneTypeProp.validate()
      var valid = false

      if (this.sceneType == 'text') {
        valid = validFormSceneTypeText.valid
      } else if (this.sceneType == 'prop') {
        valid = validFormSceneTypeProp.valid
      }

      if (valid) {
        this.fireEvent('create', { sceneType: this.sceneType, sceneText: this.scenetext, object: this.object, expiration: this.expiration })
      }
    },
    async submitFormSceneDescription() {

      const validFormDescriptionPlain = await this.$refs.formSceneDescriptionPlain.validate()
      const validFormDescriptionImg = await this.$refs.formSceneDescriptionImg.validate()
      var valid = false

      if (this.scenedescType == 'plain') {
        valid = validFormDescriptionPlain.valid
      } else if (this.scenedescType == 'img') {
        valid = validFormDescriptionImg.valid
      }

      if (valid) {
        if (this.scenedescType == 'plain') {
          this.fireEvent('updatedesc', { type: this.scenedescType, desc: this.scenedesc, index: this.tindex, })
        }else if (this.scenedescType == 'img') {
          this.fireEvent('updatedesc', { type: this.scenedescType, descImgurl: this.scenedescImgurl, descImgalt: this.scenedescImgalt, index: this.tindex, })
      }
      }
    },
  }
};

// Movable
(function () {
  var d = {}
  var isMovable = (targ) => {
    return targ.classList?.contains("vss-movable-title");
  }
  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
  document.addEventListener("mousedown", e => {
    var closestDialog = e.target.closest(".vss-movable");
    var title = closestDialog?.querySelector(".vss-movable-title");
    if (e.button === 0 && closestDialog != null && (isMovable(e.target)) || isMovable(e.target.parentNode)) {
      d.el = closestDialog // movable element
      d.handle = title // enable dlg to be moved down beyond bottom
      pos3 = e.clientX
      pos4 = e.clientY
      d.el.style.position = "fixed"
      d.el.style.margin = 0
      d.oldTransition = d.el.style.transition
      d.el.style.transition = "none"
    }
  });
  document.addEventListener("mousemove", e => {
    if (d.el === undefined) return

    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;

    d.el.style.top = (d.el.offsetTop - pos2) + "px";
    d.el.style.left = (d.el.offsetLeft - pos1) + "px";
  });
  document.addEventListener("mouseup", () => {
    if (d.el === undefined) return
    d.el.style.transition = d.oldTransition
    d.el = undefined
  });
})();

</script>

<template>
  <header>
  </header>

  <main>

    <div class="wrapper ma-5">

      <!-- SCENE TYPE -->

      <div class="leftbar" v-if="sceneTypeVisible">
        <v-container class="">
          <v-row>
            <v-col>
              <h1 class="font-rdr">Scene Type</h1>
            </v-col>
          </v-row>

          <v-row>
            <v-col>
              <hr />
            </v-col>
          </v-row>

          <v-row>
            <v-col>
              <v-btn-toggle v-model="sceneType" rounded="0" color="deep-purple-accent-3" group mandatory>
                <v-btn value="text">
                  Text
                </v-btn>
                <v-btn value="prop">
                  Object
                </v-btn>
              </v-btn-toggle>
            </v-col>
          </v-row>

          <v-row class="mr-2">
            <v-col>
              <v-form ref="formSceneTypeText">
                <v-text-field v-if="sceneType == 'text'" label="Scene Text" class="text-edit-text" v-model="scenetext"
                  :rules="rulesSceneTypeText" />
              </v-form>
              <v-form ref="formSceneTypeProp">
                <v-select v-if="sceneType == 'prop'" label="Object" :items="objectOptions" v-model="object"
                  :rules="rulesSceneTypeProp"></v-select>
              </v-form>
              <v-form ref="formSceneType">
                <v-select label="Expiration" :items="expirationOptions" v-model="expiration"></v-select>
              </v-form>
            </v-col>
          </v-row>

          <v-row class="mt-3">
            <v-col class="text-center">
              <v-btn variant="tonal" @click="submitFormSceneType">
                Create
              </v-btn>
            </v-col>
          </v-row>

        </v-container>
      </div>

      <div class="desc-box vss-movable" v-if="descriptionVisible">

        <div class="float-right mr-7 mt-2">
          <v-btn variant="text" @click="fireEvent('closeDescription')">x</v-btn>
        </div>


        <!-- EDIT DESCRIPTION -->

        <v-container class="ma-5 w-auto pl-10 pr-11 py-3">

          <v-row class="vss-movable-title">
            <v-spacer></v-spacer>
            <v-col cols="6" align-self="center">
              <div class="mx-5">
                <v-tooltip text="Scene descriptions appear when someone interacts with the scene." location="top">
                  <template v-slot:activator="{ props }">
                    <h1 class="font-rdr text-center ml-5 mr-5" v-bind="props">Scene Description</h1>
                  </template>
                </v-tooltip>
              </div>
            </v-col>
            <v-spacer></v-spacer>
          </v-row>

          <v-row>
            <v-col>
              <hr />
            </v-col>
          </v-row>

          <v-row>
            <v-col>
              <v-btn-toggle v-model="scenedescType" rounded="0" color="deep-purple-accent-3" group mandatory>
                <v-btn value="plain">
                  Text
                </v-btn>
                <v-btn value="img">
                  Image
                </v-btn>
              </v-btn-toggle>
            </v-col>
          </v-row>
          <v-row v-show="scenedescType == 'plain'">
            <v-col>
              <v-row>
                <v-col>
                  <div class="text-subtitle-1 text-white">
                    Enter this scene's description text:
                  </div>
                  <v-form ref="formSceneDescriptionPlain">
                    <v-textarea class="text-edit-textarea" v-model="scenedesc" maxlength="500" rows="5" cols="100"
                      counter></v-textarea>
                  </v-form>
                </v-col>
              </v-row>
              <v-row>
                <v-col class="text-center">
                  <v-btn variant="tonal" @click="submitFormSceneDescription">Save
                    Description</v-btn>
                </v-col>
              </v-row>
            </v-col>
          </v-row>
          <v-row v-show="scenedescType == 'img'">
            <v-col>
              <v-row>
                <v-col cols="8">
                  <v-form ref="formSceneDescriptionImg">
                    <div class="text-subtitle-1 text-white text-left">Image URL:</div>
                    <v-text-field class="text-edit-text" v-model="scenedescImgurl"
                      placeholder="https://example.com/rainbow.jpg" :rules="rulesSceneDescriptionImgUrl" />
                    <div class="text-subtitle-1 text-white text-left">Image Alt Text:</div>
                    <v-text-field class="text-edit-text" v-model="scenedescImgalt"
                      placeholder="Text from the image for people with visual impairments"
                      :rules="rulesSceneDescriptionImgAlt" />
                  </v-form>
                </v-col>
                <v-col>
                  <div v-if="scenedescType === 'img' && scenedescImgurl" class="scene-img-preview-container">
                    <img :src="scenedescImgurl" :alt="scenedescImgalt" class="scene-img-preview" />
                  </div>
                </v-col>
              </v-row>
              <v-row>
                <v-col class="text-center">
                  <v-btn variant="tonal" @click="submitFormSceneDescription">Save
                    Description</v-btn>
                </v-col>
              </v-row>
            </v-col>
          </v-row>

        </v-container>
      </div>


      <!-- EDIT APPEARANCE -->

      <div class="sidebar pb-12" v-if="appearanceVisible">

        <v-container>

          <v-row>
            <v-col class="my-0 py-0 mr-0 pr-0">
              <div class="float-right mr-2 mt-2">
                <v-btn variant="text" @click="fireEvent('closeAppearance')">x</v-btn>
              </div>

              <h1 class="font-rdr text-left mt-2 ml-2">Scene Appearance</h1>
            </v-col>
          </v-row>
          <v-row>
            <v-col>
              <hr />
            </v-col>
          </v-row>

          <v-spacer></v-spacer>
          <v-row class="mr-2">
            <v-col>

              <div v-if="sceneType == 'text'">
                <v-select label="Font" :items="fontOptions" v-model="font.selected"
                  @update:modelValue="fireEvent('updatefont', { font: parseInt(font.selected), index: tindex })"></v-select>

                <v-select label="Color" :items="colorOptions" v-model="color.selected"
                  @update:modelValue="fireEvent('updatecolor', { color: parseInt(color.selected), index: tindex })"></v-select>


                <v-select label="Background Color" :items="backgroundColorOptions" v-model="backgroundcolor.selected"
                  @update:modelValue="fireEvent('updatebackgroundcolor', { color: parseInt(backgroundcolor.selected), index: tindex })"></v-select>

                <div class="text-subtitle-1 text-white text-left">Scale:</div>
                <v-slider v-model="scale" class="align-center" :max="0.5" :min="0.3" :step="0.05" hide-details
                  @update:modelValue="fireEvent('updatescale', { scale: parseFloat(scale), index: tindex })"></v-slider>
                <div>({{ scale.toFixed(2) }})</div>

              </div>

              <div class="text-subtitle-1 text-white text-left">Location:</div>
              <div class="custom-scale mt-3">
                <div class="dpad">
                  <a class="dbutton up"
                    @click="fireEvent('moveup', { index: tindex, coords: scene.coords, distance: distance })">
                    <svg style="width:24px;height:24px" viewBox="0 0 24 24">
                      <path fill="currentColor" d="M15,20H9V12H4.16L12,4.16L19.84,12H15V20Z" />
                    </svg>
                  </a>
                  <a class="dbutton down"
                    @click="fireEvent('movedown', { index: tindex, coords: scene.coords, distance: distance })">
                    <svg style="width:24px;height:24px" viewBox="0 0 24 24">
                      <path fill="currentColor" d="M9,4H15V12H19.84L12,19.84L4.16,12H9V4Z" />
                    </svg>
                  </a>
                  <a class="dbutton left"
                    @click="fireEvent('moveleft', { index: tindex, coords: scene.coords, distance: distance })">
                    <svg style="width:24px;height:24px" viewBox="0 0 24 24">
                      <path fill="currentColor" d="M20,9V15H12V19.84L4.16,12L12,4.16V9H20Z" />
                    </svg>
                  </a>
                  <a class="dbutton right"
                    @click="fireEvent('moveright', { index: tindex, coords: scene.coords, distance: distance })">
                    <svg style="width:24px;height:24px" viewBox="0 0 24 24">
                      <path fill="currentColor" d="M4,15V9H12V4.16L19.84,12L12,19.84V15H4Z" />
                    </svg>
                  </a>

                  <div class="center">
                    <a class="dbutton forward"
                      @click="fireEvent('moveforward', { index: tindex, coords: scene.coords, distance: distance })">
                      <svg style="width:24px;height:24px" viewBox="0 0 24 24">
                        <path fill="currentColor" d="M20 14H14V20H10V14H4V10H10V4H14V10H20V14Z" />
                      </svg>
                    </a>
                    <a class="dbutton backwards"
                      @click="fireEvent('movebackward', { index: tindex, coords: scene.coords, distance: distance })">
                      <svg style="width:24px;height:24px" viewBox="0 0 24 24">
                        <path fill="currentColor" d="M20 14H4V10H20" />
                      </svg>
                    </a>
                  </div>
                </div>

              </div>

              <div v-if="sceneType == 'prop'">
                <v-btn variant="tonal" class="pt-1"
                  @click="fireEvent('rotateleft', { index: tindex, propheading: scene.propheading, distance: distance })">
                  <svg style="width:32px;height:32px" viewBox="0 0 32 40">
                    <path fill="currentColor" transform="translate(32), scale(-1, 1)"
                      d="M31,16c0,3.65-4.37,6.74-10.88,7.7A1,1,0,0,1,19,22.86a1,1,0,0,1,.85-1.14C25.14,20.94,29,18.53,29,16c0-2.9-5.22-6-13-6S3,13.1,3,16c0,2.49,3.65,4.81,8.78,5.66l-2-2a1,1,0,0,1,0-1.41,1,1,0,0,1,1.42,0l3.53,3.53a1,1,0,0,1,0,1.42l-3.53,3.53a1,1,0,0,1-1.42-1.41l1.7-1.69C5.18,22.61,1,19.6,1,16c0-4.49,6.59-8,15-8S31,11.51,31,16Z" />
                  </svg>
                </v-btn>
                <v-btn variant="tonal" class="pt-1"
                  @click="fireEvent('rotateright', { index: tindex, propheading: scene.propheading, distance: distance })">
                  <svg style="width:32px;height:32px" viewBox="0 0 32 40">
                    <path fill="currentColor"
                      d="M31,16c0,3.65-4.37,6.74-10.88,7.7A1,1,0,0,1,19,22.86a1,1,0,0,1,.85-1.14C25.14,20.94,29,18.53,29,16c0-2.9-5.22-6-13-6S3,13.1,3,16c0,2.49,3.65,4.81,8.78,5.66l-2-2a1,1,0,0,1,0-1.41,1,1,0,0,1,1.42,0l3.53,3.53a1,1,0,0,1,0,1.42l-3.53,3.53a1,1,0,0,1-1.42-1.41l1.7-1.69C5.18,22.61,1,19.6,1,16c0-4.49,6.59-8,15-8S31,11.51,31,16Z" />
                  </svg>
                </v-btn>
              </div>

            </v-col>
          </v-row>

          <v-spacer class="mt-12"></v-spacer>
          <v-row>
            <v-col class="text-center" align-self="end">
              <v-btn class="btn-delete" variant="tonal" color="#ad2525"
                @click="fireEvent('deletescene', { index: tindex })">
                Delete Scene
              </v-btn>
            </v-col>
          </v-row>
          <v-spacer></v-spacer>
        </v-container>

      </div>
    </div>


    <!-- VIEW DESCRIPTION -->

    <div class="wrapper ma-5" v-if="viewVisible">
      <div class="view-desc-box">

        <div class="float-right mr-7 mt-2">
          <v-btn variant="text" @click="fireEvent('closeView')">x</v-btn>
        </div>

        <v-container class="ma-5 w-auto pl-10 pr-11 py-3">
          <v-row>
            <v-col align-self="center">
              <div class="mx-5">
                <h1 class="font-rdr text-center ml-5 mr-5">Scene Description</h1>
              </div>
            </v-col>
          </v-row>
          <v-row>
            <v-col>
              <hr />
            </v-col>
          </v-row>
          <v-row>
            <v-col>
              <div v-if="scenedescType === 'plain'" class="ma-5">
                <span style="white-space: pre-wrap;">{{ scenedesc }}</span>
              </div>

              <div v-if="scenedescType === 'img'" class="scene-img-container">
                <img :src="scenedescImgurl" :alt="scenedescImgalt" class="scene-img" />
              </div>
            </v-col>
          </v-row>

        </v-container>
      </div>
    </div>

  </main>
</template>

<style scoped>
.vss-movable {
  cursor: grab;
}

.vss-movable:hover {
  /* background-color: #eee; */
}

.vss-movable:active {
  cursor: grabbing;
}
</style>
