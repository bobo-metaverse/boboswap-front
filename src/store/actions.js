import * as TYPES from "./types"
const actions = {
  showHeader(vuex, v) {
    vuex.commit(TYPES.IS_HEADER, v)
    
	},
}
export default actions