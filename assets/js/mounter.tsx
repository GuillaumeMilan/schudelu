import React from "react";
import { render, unmountComponentAtNode } from "react-dom";

import { Greeter, GreeterOpts } from "./greeter";

export function mount(id: string, opts: GreeterOpts) {
  const rootElement = document.getElementById(id);

  render(
    <React.StrictMode>
      <Greeter {...opts} />
    </React.StrictMode>,
    rootElement
  );

  return (el: Element) => {
    if (!unmountComponentAtNode(el)) {
      console.warn("unmount failed", el);
    }
  };
}
