/**
 * This is a library for SortableJS functionality used to generate STACK Parsons blocks.
 * 
 * @copyright  2023 University of Edinburgh
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

export const stack_sortable = class {

    constructor(proofSteps, availableId, usedId, inputId = null, options = null) {
        this.proofSteps = proofSteps;
        this.inputId = inputId;
        this.state = this._generate_state(this.proofSteps, this.inputId);
        if (inputId != null) {
            this.input = document.getElementById(this.inputId);
        };
        this.availableId = availableId;
        this.available = document.getElementById(this.availableId);
        this.usedId = usedId;
        this.used = document.getElementById(this.usedId);
        // TODO : additional default options?
        this.defaultOptions = {animation: 50};
        if (options == null) {
            this.userOptions = this.defaultOptions;
        } else {
            this.userOptions = Object.assign(this.defaultOptions, options);
        };
        // Do not allow a user to replace ghostClass or group.
        this.options = Object.assign(this.userOptions, {ghostClass: "list-group-item-info", group: "shared"});
    }

    _generate_state(proofSteps, inputId) {
        let stateStore = document.getElementById(inputId);
        return stateStore.value && stateStore.value != "" ? JSON.parse(stateStore.value) : {used: [], available: [...Object.keys(proofSteps)]};
    }

    generate_available() {
        for (const key in this.state.available) {
            let li = document.createElement("li");
            li.innerHTML = this.proofSteps[this.state.available[key]];
            li.setAttribute("data-id", this.state.available[key]);
            li.className = "list-group-item";
            this.available.append(li);
        };
    }

    generate_used() {
        for (const key in this.state.used) {
            let li = document.createElement("li");
            li.innerHTML = this.proofSteps[this.state.used[key]];
            li.setAttribute("data-id", this.state.used[key]);
            li.className = "list-group-item";
            this.used.append(li);
        };
    }

    update_state(newUsed, newAvailable) {
        var newState = {used: [], available: []};
        newState.used = newUsed.toArray();
        newState.available = newAvailable.toArray();
        if (this.inputId != null) {
            this.input.value = JSON.stringify(newState);
            this.input.dispatchEvent(new Event('change'));
        };
        this.state = newState;
    }
};

export default {stack_sortable};
