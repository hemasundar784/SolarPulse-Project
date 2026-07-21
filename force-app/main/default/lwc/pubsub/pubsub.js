// pubsub.js
const events = {};

const registerListener = (eventName, callback, thisArg) => {
    if (!events[eventName]) {
        events[eventName] = [];
    }
    const duplicate = events[eventName].find(listener => {
        return listener.callback === callback && listener.thisArg === thisArg;
    });
    if (!duplicate) {
        events[eventName].push({ callback, thisArg });
    }
};

const unregisterListener = (eventName, callback, thisArg) => {
    if (events[eventName]) {
        events[eventName] = events[eventName].filter(
            listener => listener.callback !== callback || listener.thisArg !== thisArg
        );
    }
};

const unregisterAllListeners = thisArg => {
    Object.keys(events).forEach(eventName => {
        events[eventName] = events[eventName].filter(
            listener => listener.thisArg !== thisArg
        );
    });
};

const fireEvent = (pageRef, eventName, payload) => {
    if (events[eventName]) {
        events[eventName].forEach(listener => {
            try {
                listener.callback.call(listener.thisArg, payload);
            } catch (error) {
                // eslint-disable-next-line no-console
                console.error(error);
            }
        });
    }
};

export {
    registerListener,
    unregisterListener,
    unregisterAllListeners,
    fireEvent
};
