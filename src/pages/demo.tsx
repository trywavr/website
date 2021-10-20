import React, { useEffect, useState } from 'react';
import { styled } from '@stitches/react';
import { useRouter } from 'next/router';
import { Step0, Step2, Step3 } from '../components/demo';
import { Button } from '../components/button';
import { AnimatedHeading } from '../components/demo/animated-heading';
// @ts-ignore
import { initialize, start, stop, send } from '../utils/wags/handoff';

const Container = styled('div', {
  height: '84vh',
  display: 'flex',
  flexDirection: 'column',
  justifyContent: 'space-between',
  maxWidth: '600px',
  margin: '40px auto 0 auto',
});

const Demo = () => {
  const router = useRouter();
  const [demoInitialized, setDemoInitialized] =
    useState<DemoInitialized | void>();
  const [demoStarted, setDemoStarted] = useState<DemoStarted | void>();
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
      await start((s: string) => () => console.error(s))(
        demoInitialized
      )().then(setDemoStarted);
      send(demoInitialized)({
        tag: "DE'Music_was_never_meant_to_be_static_or_fixed",
      })();
    } else {
      console.error('Initialization not done yet');
    }
  };
  return (
    <Container>
      <div>
        {step === 0 && (
          <>
            <AnimatedHeading text="Peek into what's possible" />
            <Step0 />
          </>
        )}
        {step === 1 && (
          <>
            <AnimatedHeading text="Music was never meant to be static or fixed." lineTwo="Music must explode with possibilities." />
            <Button onClick={startExample} size='3' variant="transparentWhite">Make sound</Button>
          </>
        )}
        {step === 2 && (
          <>
            <AnimatedHeading text="The possibility to add new sounds..." />
            <Step2 />
          </>
        )}
        {step === 3 && (
          <>
            <AnimatedHeading text="The possibility to take a sound in a new direction..." />
            <Step3 />
          </>
        )}
      </div>

      <div style={{ display: 'flex' }}>
        <Button onClick={() => step > 0 && setStep(step - 1)} size={2}>Back</Button>
        <div style={{ width: 16 }} />
        <Button
          size={2}
          onClick={() => {
            step === 0 &&
              initialize().then(
                (res: DemoInitialized) => setDemoInitialized(res),
                (err: Error) => console.log(err)
              );
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
