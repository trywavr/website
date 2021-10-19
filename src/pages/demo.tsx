import React, { useEffect, useState } from 'react';
import { styled } from '@stitches/react';
import { useRouter } from 'next/router';
import { Step0 } from '../components/demo/step-0';
import { Button } from '../components/button';
import { AnimatedHeading } from '../components/demo/animated-heading';
// @ts-ignore
import { initialize, start, stop, send } from '../utils/wags/handoff';

const Container = styled('div', {
  marginTop: '40px',
  height: '84vh',
  display: 'flex',
  flexDirection: 'column',
});

const Demo = () => {
  const router = useRouter();
  const [demoInitialized, setDemoInitialized] =
    useState<DemoInitialized | void>();
  const [demoStarted, setDemoStarted] =
    useState<DemoStarted | void>();
  const { stepNumber } = router.query;
  const stepQueryParams =
    stepNumber && typeof stepNumber === 'string'
      ? parseInt(stepNumber)
      : undefined;
  const [step, setStep] = useState<number>(stepQueryParams || 0);

  useEffect(() => {
    setStep(stepQueryParams || 0);
  }, [stepNumber]);

  const startExample = async () => {
    demoStarted && stop(demoStarted)();
    if (demoInitialized) {
      await start((s: string) => () => console.error(s))(demoInitialized)().then(setDemoStarted);
      send(demoInitialized)({
        tag: "DE'Music_was_never_meant_to_be_static_or_fixed"
      })();
    } else {
      console.error("Initialization not done yet");
    }
  };
  return (
    <Container>
      {step === 0 && (
        <>
          <AnimatedHeading text="Peek into what's possible" />
          <Step0 />
        </>
      )}
      {step === 1 && (
        <>
          <AnimatedHeading text="Hello" /> <Button onClick={startExample}>Make sound</Button>
        </>
      )}

      <div
        style={{
          display: 'flex',
          justifyContent: 'flex-end',
          alignSelf: 'flex-end',
        }}
      >
        <Button
          size={2}
          onClick={() => {
            step === 0 && initialize().then((res: DemoInitialized) => setDemoInitialized(res), (err: Error) => console.log(err));
            router.push(`/demo?stepNumber=${step + 1}`);
          }}
        >
          Next
        </Button>
      </div>
    </Container>
  );
};

export default Demo;
