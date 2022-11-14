import React from "react";

export interface GreeterProps {
  name: string;
}

export const Greeter: React.FC<GreeterProps> = (props: GreeterProps) => {
  const { name, count } = props;
  return (
    <section className="phx-hero">
      <h1>Welcome to {name} with TypeScript and React!</h1>
      <div> Counter = {count}</div>

    </section>
  );
};
