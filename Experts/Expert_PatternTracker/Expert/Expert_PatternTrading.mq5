/* Page       Expert_Configuration - Expert_SimpleTrendTrading.mq5
 ******************************************************************************
 * $Copyright$        Copyright 2020, Toda Alin-Petru
 *
 ******************************************************************************
 * $FileInformation$
 * $Author:           Toda, Alin-Petru
 * $Revision:         1.00
 *
 ******************************************************************************
 *
 * $Updates:          Initial revision.
 *
 *****************************************************************************/

/* ToDo
 *
 */

#property copyright "Copyright 2019, MetaQuotes Software Corp. Toda Alin-Petru"
#property link      "https://www.mql5.com"
#property version   "1.00"

/*--------------------------------------------------------------------------------------------------------------*/
/*                                            I N C L U D E S                                                   */
/*--------------------------------------------------------------------------------------------------------------*/
#include <MoneyManagement/MoneyManagement.mqh>
#include <Toda_FX_Environment/Components/TaskHandler/TaskHandler.mqh>

#include "cfg/Expert_Configuration.mqh"
#include "IF/Expert_Control_gIF.mqh"

/*--------------------------------------------------------------------------------------------------------------*/
/*                                         G L O B A L   D A D A                                                */
/*--------------------------------------------------------------------------------------------------------------*/
MoneyManagement * MM;
TaskHandler * TaskH;
ExThis_Expert * ENV_Expert;

/*--------------------------------------------------------------------------------------------------------------*/
/*                                            F U N C T I O N S                                                 */
/*--------------------------------------------------------------------------------------------------------------*/


/* OnInit()
 ********************************************************************
 * Desc:     Initialization function
 *
 *******************************************************************/
int OnInit(){

    /* Initialize Task Handler */
    TaskH = new TaskHandler( str_TaskH_cfg );

    /* Initialize Money Management Component*/
    MM = new MoneyManagement( str_MM_cfg );

    /* Initialize Expert */
    ENV_Expert = new ExThis_Expert( 0x6257, Expert_Config );

    /* Wait until second 00 of the minute */
    Sleep( TaskH.getSleepPeriod() );

    /* Set timer to defined period */
    EventSetTimer( TIMER_PERIOD_60_SEC );   // timer

    /* Acknowledge end of initialization */
    Print( __FUNCTION__ + "(): INIT_SUCCEEDED" );

    return( INIT_SUCCEEDED );
}




/* OnDeinit()
 ********************************************************************
 * Desc:     Deinitialization function
 *
 *******************************************************************/
void OnDeinit(const int reason){
    delete( TaskH );
    delete( MM );

    delete( ENV_Expert );

    /* Destroy timer */
    EventKillTimer();
    Print( __FUNCTION__ + "(): DEINIT_SUCCEEDED" );
}



/* OnTick()
 ********************************************************************
 * Desc:     "Tick" event handler function
 *
 *******************************************************************/
void OnTick(){

    /* Execute expert on tivk routine */
    ENV_Expert.onTick();

}

/* OnTrade()
 ********************************************************************
 * Desc:     "Trade" event handler function
 *
 *******************************************************************/
void OnTrade(){

    /* Update situation after very trade */
    MM.updateMonaySituation( NORMAL );

    /* Execute expert on trade routine */
    ENV_Expert.onTrade();

}

/* OnTimer()
 ********************************************************************
 * Desc:     "Timer" event handler function
 *
 *******************************************************************/
void OnTimer(){

    if( TaskH.isTask( TASK_01_MIN ) ){        /* Start  1 minute task */
        /* Call Expert 01_MIN */
        ENV_Expert.onTimer( TASK_01_MIN, MM.isTradeAllowed(), MM.getLotSize() );
    }

    if( TaskH.isTask( TASK_05_MIN ) ){        /* Start 5 minute task */
        /* Call Expert 05_MIN */
        ENV_Expert.onTimer( TASK_05_MIN, MM.isTradeAllowed(), MM.getLotSize() );
    }

    if( TaskH.isTask( TASK_15_MIN ) ){        /* Start 15 minute task */
        /* Call Expert 15_MIN */
        ENV_Expert.onTimer( TASK_15_MIN, MM.isTradeAllowed(), MM.getLotSize() );
    }

    if( TaskH.isTask( TASK_30_MIN ) ){        /* Start 30 minute task */
        /* Call Expert 30_MIN */
        ENV_Expert.onTimer( TASK_30_MIN, MM.isTradeAllowed(), MM.getLotSize() );
    }

    if( TaskH.isTask( TASK_01_HOUR ) ){        /* Start 1 hour task */
        /* Call Expert 01_HOUR */
        ENV_Expert.onTimer( TASK_01_HOUR, MM.isTradeAllowed(), MM.getLotSize() );
    }

    if( TaskH.isTask( TASK_04_HOUR ) ){        /* Start  4 hour task */
        /* Call Expert 04_HOUR */
        ENV_Expert.onTimer( TASK_04_HOUR, MM.isTradeAllowed(), MM.getLotSize() );
    }

    if( TaskH.isTask( TASK_12_HOUR ) ){        /* Start 12 hour task */
        /* Call Expert 12_HOUR */
        ENV_Expert.onTimer( TASK_12_HOUR, MM.isTradeAllowed(), MM.getLotSize() );
    }

    if( TaskH.isTask( TASK_24_HOUR ) ){        /* Start 24 hour task */
        /* Call Expert 24_HOUR */
        ENV_Expert.onTimer( TASK_24_HOUR, MM.isTradeAllowed(), MM.getLotSize() );
    }


    /* Execute end-of week */ // ToDo optional or not
    if( MM.isEndOfWeek() ){ ENV_Expert.executeShutdown(); }

    /* Update situation every minute */
    MM.updateMonaySituation( OVERRIDE );

    #ifdef ENABLE_TASK_HANDLER_TESTMODE
        TaskH.executeTestMode();
    #endif

}




